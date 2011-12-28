require "sinatra/base"
require "./cruisecontrolrb"
require "./hipchat"

class CruisecontrolrbToHipchat < Sinatra::Base
    
  attr_accessor :status
  
  scheduler = Rufus::Scheduler.start_new
  
  scheduler.every("#{ENV["POLLING_INTERVAL"] || 1}m") do  
    status = Cruisecontrolrb.new(ENV["CC_URL"], ENV["CC_USERNAME"], ENV["CC_PASSWORD"]).fetch
    if status != @status
      @status = status
      color = status == "Success" ? "green" : "red"
      
      Hipchat.post("https://api.hipchat.com/v1/rooms/message?" + 
      "auth_token=#{ENV["HIPCHAT_AUTH_TOKEN"]}" +
      "&message=Current+build+status%3A+#{status}" +
      "&from=#{ENV["HIPCHAT_FROM"]}" +
      "&room_id=#{ENV["HIPCHAT_ROOM_ID"]}" + 
      "&color=#{color}")
    end
  end
  
  get "/" do
    "howdy!"
  end
end
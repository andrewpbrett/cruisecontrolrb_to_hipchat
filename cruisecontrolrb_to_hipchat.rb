require "sinatra/base"
require "./cruisecontrolrb"
require "./hipchat"

class CruisecontrolrbToHipchat < Sinatra::Base
    
  attr_accessor :status
  
  scheduler = Rufus::Scheduler.start_new
  
  scheduler.every("#{ENV["POLLING_INTERVAL"] || 1}m") do  
    status_hash = Cruisecontrolrb.new(ENV["CC_URL"], ENV["CC_USERNAME"] || "", ENV["CC_PASSWORD"] || "").fetch
    if status_hash[:lastBuildStatus] != @status
      @status = status[:lastBuildStatus]
      color = status[:lastBuildStatus] == "Success" ? "green" : "red"
      
      Hipchat.post("https://api.hipchat.com/v1/rooms/message?" + 
      "auth_token=#{ENV["HIPCHAT_AUTH_TOKEN"]}" +
      "&message=#{URI.escape("Current+build+status%3A+<a href=\"" + 
      status[:webUrl] + "/" + status[:lastBuildLabel] + "\">" + status + "</a>")}" +
      "&from=#{ENV["HIPCHAT_FROM"] || "cruise-control"}" +
      "&room_id=#{ENV["HIPCHAT_ROOM_ID"]}" + 
      "&color=#{color}")
    end
  end
  
  get "/" do
    Cruisecontrolrb.new(ENV["CC_URL"], ENV["CC_USERNAME"] || "", ENV["CC_PASSWORD"] || "").fetch
  end
end
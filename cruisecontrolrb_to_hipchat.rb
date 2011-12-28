require "sinatra/base"
require "./cruisecontrolrb"
require "./hipchat"

class CruisecontrolrbToHipchat < Sinatra::Base
    
  attr_accessor :status
  
  scheduler = Rufus::Scheduler.start_new
  
  scheduler.every("#{ENV["POLLING_INTERVAL"] || 1}m") do  
    status_hash = Cruisecontrolrb.new(ENV["CC_URL"], ENV["CC_USERNAME"] || "", ENV["CC_PASSWORD"] || "").fetch
    if !status_hash.empty? and status_hash[:lastBuildStatus] != @status
      @status = status_hash[:lastBuildStatus]
      
      color = status_hash[:lastBuildStatus] == "Success" ? "green" : "red"
      
      url = status_hash[:webUrl].gsub("projects", "builds")
      
      Hipchat.post("https://api.hipchat.com/v1/rooms/message?" + 
      "auth_token=#{ENV["HIPCHAT_AUTH_TOKEN"]}" +
      "&message=#{URI.escape("Current+build+status:+<a href=\"" + 
      url + "/" + status_hash[:lastBuildLabel] + "\">" + status_hash[:lastBuildStatus] + "</a>")}" +
      "&from=#{ENV["HIPCHAT_FROM"] || "cruise-control"}" +
      "&room_id=#{ENV["HIPCHAT_ROOM_ID"]}" + 
      "&color=#{color}")
    end
  end
  
  get "/" do
    "howdy!"
  end
end
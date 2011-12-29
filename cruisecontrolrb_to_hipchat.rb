require "sinatra/base"
require "./cruisecontrolrb"
require "./hipchat"

class CruisecontrolrbToHipchat < Sinatra::Base
    
  attr_accessor :status
  attr_accessor :activity
  
  scheduler = Rufus::Scheduler.start_new
  
  scheduler.every("#{ENV["POLLING_INTERVAL"] || 1}m") do  
    
    puts "here" 
    
    status_hash = Cruisecontrolrb.new(ENV["CC_URL"], ENV["CC_USERNAME"] || "", ENV["CC_PASSWORD"] || "").fetch
    
    puts status_hash
    puts @activity
    puts @status
    
    unless status_hash.empty?        
      if status_hash[:activity] == "Building" and @activity != "Building"
        Hipchat.new.hip_post "CruiseControl has started a #{status_hash[:link_to_build]}."
        @activity = "Building"
        puts "building"
      # there might be a more clever way to structure this.
      elsif @activity == "Building" and status_hash[:activity] != "Building"
        @activity = status_hash[:activity]
        @status = status_hash[:lastBuildStatus]
      
        color = status_hash[:lastBuildStatus] == "Success" ? "green" : "red"
      
        message = "Current+build+status:+#{status_hash[:link_to_build]}"
          
        Hipchat.new.hip_post message, color
      end
    end
  end
  
  get "/" do
    "howdy!"
  end
end
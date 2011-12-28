require 'httparty'

class Hipchat
  include HTTParty
  
  def hip_post message, color = nil
    self.class.post("https://api.hipchat.com/v1/rooms/message?" + 
      "auth_token=#{ENV["HIPCHAT_AUTH_TOKEN"]}" +
      "&message=#{URI.escape(message)}" +
      "&from=#{ENV["HIPCHAT_FROM"] || "cruise-control"}" +
      "&room_id=#{ENV["HIPCHAT_ROOM_ID"]}" + 
      "&color=#{color}")
  end
    
end
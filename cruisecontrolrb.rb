require 'httparty'
require 'nokogiri'

class Cruisecontrolrb
  
  include HTTParty
  
  def initialize base_url, username = nil, password = nil
    @auth = { :username => username, :password => password }
    @base_url = base_url
  end
  
  def fetch
    options = { :basic_auth => @auth }

    noko = Nokogiri::XML(self.class.get("http://#{@base_url}/XmlStatusReport.aspx", options).parsed_response)

    return {} unless noko.search("Project").first
    
    status_hash = { :lastBuildStatus => noko.search("Project").first.attributes["lastBuildStatus"].value,
      :webUrl => noko.search("Project").first.attributes["webUrl"].value,
      :lastBuildLabel => noko.search("Project").first.attributes["lastBuildLabel"].value,
      :activity => noko.search("Project").first.attributes["activity"].value }

    link_text = status_hash[:activity] == "Building" ? "build" : status_hash[:lastBuildStatus]
    url = status_hash[:webUrl].gsub("projects", "builds")
    
    status_hash[:link_to_build] = "<a href=\"" + url + "/" + status_hash[:lastBuildLabel] + 
      "\">" + link_text + "</a>"
      
    status_hash
  end
  
end
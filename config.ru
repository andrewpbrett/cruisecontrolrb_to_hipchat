require "rubygems"
require "sinatra"
require "bundler"

Bundler.require

require "./cruisecontrolrb_to_hipchat"

run CruisecontrolrbToHipchat
# encoding: UTF-8
require './czfaker-api.rb'

use Raven::Rack
run CzFakerAPI.new

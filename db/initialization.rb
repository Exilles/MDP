require 'sequel'
require 'pg'
require 'yaml'
require 'erb'

DB=Sequel.connect(YAML.load(ERB.new(File.read('config/database.yml')).result)['production'])

require_relative 'models/ad'
require_relative 'models/lot'
require_relative 'models/item'
require_relative 'models/user'
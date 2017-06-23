require 'sequel'
require 'pg'
require 'yaml'
require 'erb'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

require_relative 'db/Model/ad'
require_relative 'db/Model/lot'
require_relative 'db/Model/item'
require_relative 'db/Model/user'

newItem = Item.create(:name => 'smartphone')

usert = User[:login => 'Misha']

usert.items

usert.add_item(newItem)




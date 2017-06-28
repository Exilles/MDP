
require 'yaml'
require 'yaml/store'
require 'sequel'

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market_db', :user=>'admin', :password=>'111')

require_relative 'db/Model/item'
require_relative 'lib/item_def'


items = Item.new('item.yml').all

items.each do |item|
  puts item['name']
  puts item['cost']
end



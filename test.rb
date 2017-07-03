require 'nokogiri'
require 'yaml'
require 'yaml/store'
require 'sequel'
require 'benchmark'
DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'market_db', :user => 'admin', :password => '111')

require_relative 'db/Model/lot'
require_relative 'lib/lot_def'
require_relative 'db/Model/item'
require_relative 'lib/item_def'
require_relative 'db/Model/ad'
require_relative 'lib/ads_def'
require_relative 'db/Model/user'
require_relative 'lib/user_def'

# id = 1
# Lot.where(:user_id => id).each do |userlot|
#   puts userlot.price
# end


# def test
#   Nokogiri::XML::Builder.new {|xml|
#     xml.lots "Lots" do
#       Lot.where(:user_id => 1).each do |userlot|
#         xml.lot :price => userlot.price, :count => userlot.count_lot
#       end
#     end
#   }.to_xml
#
# end
#
#
# # @i = 1
# # begin
# #   Item.insert(:item_id => rand(1..20), :count_item => rand(1..10), :user_id => 1)
# #   @i = @i + 1
# # end while @i < 1000
# #
#
# all_items = Item.new('item.yml').all
#
#
# n = 1000
# Benchmark.bm do |x|
# x.report { n.times do ;   Nokogiri::XML::Builder.new {|xml|
#   xml.items "Inventory" do
#     Item.where(:user_id => 1).each do |useritem|
#       #item = all_items[useritem.item_id - 1]
#       xml.item :cost => all_items[useritem.item_id - 1].cost , :name => all_items[useritem.item_id - 1].name, :count => useritem.count_item
#     end
#   end
# }.to_xml; end }
# end


# all_items = Item.new('item.yml').all
#
# xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n" + "<inventory>\n"
# Item.where(:user_id => 1).each do |item|
#   xml << "  <item name=\"#{all_items[item.item_id - 1].name}\" count=\"#{item.count_item}\" cost=\"#{all_items[item.item_id - 1].cost}\">\n"
# end
# xml << "</inventory>"

# all_items = Item.new('item.yml').all
# # #
# # # puts all_items[Item[:id => 1002].item_id].name
# # Lot.where(:user_id => 1).each do |lot|
# #   puts all_items[Item[:id => lot.item_id].item_id].name
# #
# # end
#
# filter_params = 'game magic'
# filter_params = filter_params.split(' ')
# ad = Ad
# i = 0
#
# while i<filter_params.size
#   Lot.
#   ad = Lot.where(:item_id => )
#   i = i+1
# end
#
#
# xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
# ad.each do |ads|
#   xml << "  <nickname=\"#{User[:id => Lot[:id => ads.lot_id].user_id].login}\" title = \"#{ads.name}\" description=\"#{ads.description}\">\n"
# end
# xml << "</ads>"
#
# puts xml

filter = DB[:lots].join_table(:inner, DB[:ads], :id => :ad_id)
filter.where(:name => 'Меч', :price => 150, :count_lot => 2)
filter.each do |t|
 t.each { |key, value| puts "#{key} => #{value}" }
 test=t.fetch(:id)
  puts test
end
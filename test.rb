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
# price_lot = 150
# name_lot
# count_lot
#
# filter = DB[:lots].join_table(:inner, DB[:ads], :id => :ad_id)
#
# if name_lot!= nil
#  filter =  filter.where(:name => name_lot) #фильтр по названию объявления
# end
#
# if price_lot!=nil
#  filter = filter.where(:price => price_lot) #фильтр по цене
# end
#
# if count_lot!=nil
#  filter = filter.where(:count_lot => count_lot) #фильтр по количеству предметов в лоте
# end
#
# xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
# filter.each do |ads|
#  xml << "  <Nickname=\"#{User[:id => ads.fetch(:user_id)].login}\" name = \"#{ads.fetch(:name)}\" description=\"#{ads.fetch(:description)}\">\n"
# end
# xml << "</ads>"
#
# puts xml
mutex = Mutex.new
threads = []
lot = Lot.new
[1, 3, 4].each do |host|
 threads << Thread.new do
  mutex.synchronize do
   lot.buy_lot(21,1,host)
   end
 end
end

threads.each(&:join)

n = 1
lot = Lot.new
Benchmark.bm do |x|
x.report { n.times do ;
lot.buy_lot(19,1,2)
end
}
end



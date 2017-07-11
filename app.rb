require 'sinatra'
require 'pg'
require 'sequel'
require 'yaml'
require 'erb'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

require_relative 'lib/item_yml'
require_relative 'lib/item_store'
require_relative 'db/models/ad'
require_relative 'db/models/lot'
require_relative 'db/models/item'
require_relative 'db/models/user'
require_relative 'controls/registration'
require_relative 'controls/inventory'
require_relative 'controls/lot'
require_relative 'controls/ads'
require_relative 'controls/errors'

store = ItemStore.new('config.yml').all

get '/registration' do

  content_type 'xml'
  register_valid(params['login'].to_s, params['password'].to_s)

end

get('/inventory') do

  content_type 'xml'
  inventory_valid(params['user_id'].to_s, store)

end

get '/lots' do

  content_type 'xml'
  market_valid(params['user_id'].to_s, store)

end

get '/lots/add' do

  content_type 'xml'
  add_lot_valid(params['user_id'].to_s, params['item_id'].to_s, params['count'].to_s, params['price'].to_s, store)

end

get '/lots/return' do

  return_lot(params['user_id'].to_i, params['lot_id'].to_i)

end

get '/lots/buy' do

  buy_lot(params['user_id'].to_i, params['lot_id'].to_i, params['count'].to_i)

end


get '/ads' do

  content_type 'xml'
  show_ads

end

get '/ads/add' do

  add_ad(store, params['user_id'].to_i, params['lot_id'].to_i)

end

get '/ads/delete' do

  delete_ad(params['user_id'].to_i, params['ad_id'].to_i)

end

get ('/ads/filter') do

  content_type 'xml'
  filter_ads(params['name'], params['count'], params['price'])

end
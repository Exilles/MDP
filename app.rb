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
require_relative 'controls/login'
require_relative 'controls/inventory'
require_relative 'controls/lots'
require_relative 'controls/ads'
require_relative 'controls/errors'

store = ItemStore.new('config.yml').all

enable :sessions

get '/login' do

  content_type 'text'
  error = login_valid(params['login'].to_s, params['password'].to_s)
  if error == ""
    session['user_id'] = login(params['login'].to_s, params['password'].to_s)
    "You have successfully signed in."
  else
    "The data you entered is:\nLogin: #{params['login']}\nPassword: #{params['password']}\n" + error
  end

end

get '/registration' do

  content_type 'text'
  error = register_valid(params['login'].to_s, params['password'].to_s)
  if error == ""
    session['user_id'] = registration(params['login'].to_s, params['password'].to_s)
    "Account successfully registered!\nLogin: #{params['login']}\nPassword: #{params['password']}"
  else
    "The data you entered is:\nLogin: #{params['login']}\nPassword: #{params['password']}\n" + error
  end

end

get('/inventory') do

  content_type 'text'
  show_inventory(store, session['user_id'])

end

get '/lots' do

  content_type 'text'
  if session['user_id']
    show_lots(store, session['user_id'].to_i)
  elsif params['user_id']
    show_lots(store, params['user_id'].to_i)
  end

end

get '/lots/add' do

  add_lot(session['user_id'].to_i, params['item_id'].to_i, params['count'].to_i, params['price'].to_i, store[0].cost.to_i)

end

get '/lots/return' do

  return_lot(session['user_id'].to_i, params['lot_id'].to_i)

end

get '/lots/buy' do

  buy_lot(session['user_id'].to_i, params['lot_id'].to_i, params['count'].to_i)

end


get '/ads' do

  content_type 'text'
  show_ads

end

get '/ads/add' do

  add_ad(store, session['user_id'].to_i, params['lot_id'].to_i)

end

get '/ads/delete' do

  delete_ad(session['user_id'].to_i, params['ad_id'].to_i)

end

get ('/ads/filter') do

  content_type 'text'
  filter_ads(params['name'], params['count'], params['price'])

end
require 'nokogiri'
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

store = ItemStore.new('config.yml').all

enable :sessions

get('/inventory') do

  content_type 'text'
  erb show_inventory(store, params['id'])

end

get '/inventory/new' do

  erb :new

end

get '/registration' do

  erb :registration

end

get '/lots' do

  content_type 'text'
  erb show_lots(store, params['id'])

end

get '/marketplace/:name' do

  erb :marketplace

end

get '/callboard' do

  erb :callboard

end

get '/' do

  erb :login

end

get '/lots/add/' do

  if add_lot(params['user_id'].to_i, params['item_id'].to_i, params['count'].to_i, params['price'].to_i)
    "Lot added :)"
  else
    "Lot NOT added :("
  end

end

get '/lots/return/' do

  if return_lot(params['id'].to_i)
    "Lot return :)"
  else
    "Lot NOT return :("
  end

end

post '/registration/accept' do
  if params['login'] != "" && params['password'] != ""
    registration(params['login'], params['password'])
    redirect '/inventory'
  else
    redirect '/registration'
  end
end

post '/login' do
  @id = login(params['login'], params['password'])
  if @id
    session['id'] = @id
    redirect to '/inventory'
  else
    redirect '/'
  end
end

post '/inventory/create' do
  @item = Item.new
  @item.name = params['name']
  @item.count = params['count']
  @item.cost = params['cost']
  store.save(@item)
  redirect '/inventory/new'
end

post '/marketplace/go' do
  if params['name'] != ""
    redirect '/marketplace/:name'
  else
    redirect '/inventory'
  end
end

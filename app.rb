require 'sinatra'
require 'item'
require 'item_store'
require 'pg'
require 'sequel'

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market', :user=>'admin', :password=>'111')
store = ItemStore.new('config.yml')

get('/inventory') do
  @items = store.all
  erb :inventory
end

get('/inventory/new') do
    erb :new
end

get('/registration') do
  erb :registration
end

get('/marketplace/:name') do
  erb :marketplace
end

get('/callboard') do
  erb :callboard
end

get('/') do
  erb :login
end

post('/registration/accept') do
  if params['login'] != "" && params['password'] != ""
    DB[:'users'].insert(:login => params['login'], :password => params['password'], :money => 100)
    redirect '/inventory'
  else
    redirect '/registration'
  end
end

post('/inventory') do
  # if params['login'] != "" && params['password'] != "" && DB[:users].where(:login => params['login'], :password => params['password'])
  if DB[:users].where(:login => 'Dima', :password => '111')
    redirect '/inventory'
  else
    redirect '/'
  end
end

post('/inventory/create') do
  @item = Item.new
  @item.name = params['name']
  @item.count = params['count']
  @item.cost = params['cost']
  store.save(@item)
  redirect '/inventory/new'
end

post ('/marketplace/go') do
  if params['name'] != ""
    redirect '/marketplace/:name'
  else
    redirect '/inventory'
  end
end

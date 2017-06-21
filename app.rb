require 'sinatra'
require 'item'
require 'item_store'
require 'pg'
require 'sequel'

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market', :user=>'admin', :password=>'111')
store = ItemStore.new('item.yml')

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

post('/registration/accept') do
  DB[:users].insert(:login => params['login'].to_s, :password => params['password'].to_s, :money => 100)
  redirect '/inventory'
end

post('/inventory/create') do
  @item = Item.new
  @item.name = params['name']
  @item.count = params['count']
  @item.cost = params['cost']
  store.save(@item)
  redirect '/inventory/new'
end

get('/') do
  erb :login
end
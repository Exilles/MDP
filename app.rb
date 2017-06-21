require 'sinatra'
require 'item'
require 'item_store'
require 'pg'
require 'sequel'

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

get('/marketplace') do
  erb :marketplace
end

get('/callboard') do
  erb :callboard
end

post('/registration/accept') do

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
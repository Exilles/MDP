require 'sinatra'
require 'item'
require 'item_store'

store = ItemStore.new('item.yml')

get('/inventory') do
  @items = store.all
  erb :inventory
end

get('/inventory/new') do
  erb :new
end

post('/inventory/create') do
  @item = Item.new
  @item.name = params['name']
  #@item.count = params['count']
  @item.cost = params['cost']
  store.save(@item)
  redirect '/inventory/new'
end

get('/inventory/:id') do
  id = params['id'].to_i
  @item = store.find(id)
  erb :show
end
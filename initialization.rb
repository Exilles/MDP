require 'sequel'
require 'pg'
require 'yaml'
require 'erb'
require 'sinatra'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

require_relative 'db/Model/ad'
require_relative 'db/Model/lot'
require_relative 'db/Model/item'
require_relative 'db/Model/user'

require_relative 'lib/ads_def'
require_relative 'lib/lot_def'
require_relative 'lib/user_def'
require_relative 'lib/item_store'

enable :sessions

get('/') do
  erb :authorization
end

#авторизация
post '/login' do
  @user = User.new
  @user.id  = @user.authorization(params['login'], params['password'])

  if @user.id
    session['id']= @user.id
    redirect to ('/inventory')
  else
    redirect '/'
  end
end

#инвентарь пользователя
get '/inventory' do
  session['id']
  @user = User.new
  @item = @user.get_user_inventory(session['id'])
  erb :inventory
end

#html отображения для лотов
get ('/lot/new') do
 erb :new_lot
end

patch ('/lot/edit') do
  erb :edit_lot
end

get ('/lot/show') do
  erb :show_lot
end

post ('lot/create') do

end

delete ('lot/delete') do
  erb :destroy_lot
end


#html отображения для объявлений
get ('/ad/new') do
  erb :new_ad
end

patch ('/ad/edit') do
  erb :edit_ad
end

get ('/ad/show') do
  erb :show_ad
end

post ('ad/create') do

end

delete ('ad/delete') do
  erb :destroy_ad
end


# usert.items
#
# usert.add_item(newItem)




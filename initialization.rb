require 'sequel'
require 'pg'
require 'yaml'
require 'erb'
require 'sinatra'
require 'nokogiri'
require 'rexml/document'
require 'yaml/store'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

require_relative 'db/Model/ad'
require_relative 'db/Model/lot'
require_relative 'db/Model/item'
require_relative 'db/Model/user'

require_relative 'lib/ads_def'
require_relative 'lib/lot_def'
require_relative 'lib/user_def'
require_relative 'lib/item_def'

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
  content_type 'text'
  session['id']
  @user = User.new
  @xml = @user.get_user_inventory(session['id'])
  erb @xml
end

#html отображения для лотов
get ('/lot/new') do
 erb :new_lot
end

patch ('/lot/edit') do
  erb :edit_lot
end

get ('/lot/show') do
  content_type 'text'
  session['id']
  @lot = Lot.new
  @xml = @lot.get_user_lots(session['id'])
  erb @xml
end

get ('/lot/create') do

  @lot=Lot.new
  session['id']
  if (session['id']!=nil && params[:item_id]!=nil && params[:price]!=nil && params[:count_lot]!=nil)
    @lot.create_new_lot(session['id'], params[:item_id], params[:price], params[:count_lot])
  else
    redirect '/lot/show'
  end
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




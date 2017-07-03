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
get ('/lot/return') do
  session['id']
  @lot = Lot.new
  @lot.return_lot(params['id'], session['id'])
  'Лот успешно возвращен'
end

patch ('/lot/edit') do
  session['id']
end

get ('/lot/show') do
  content_type 'text'
  session['id']
  @lot = Lot.new
  if params['id'] != nil
   @xml = @lot.get_user_lots(params['id'])
  else
   @xml = @lot.get_user_lots(session['id'])
  end
  erb @xml
end

get ('/lot/add') do
  @lot=Lot.new
  session['id']
  if (session['id']!=nil && params[:item_id]!=nil && params[:price]!=nil && params[:count_lot]!=nil)
    if @lot.create_new_lot(session['id'], params[:item_id], params[:price], params[:count_lot])
      'Лот успешно добавлен'
     else
      'Ошибка ввода данных'
    end
  else
    'Ошибка ввода данных'
  end
end

get ('/lot/buy') do
  @lot = Lot.new
  session['id']
  if @lot.buy_lot(params['lot_id'].to_i, params['count'].to_i, session['id'])
    'Товар успешно приобретен'
  else
    'Ошибка покупки товара'
  end
end


get ('/lot/delete') do
  @lot = Lot.new
  @lot.delete_lot(params['id'], session['id'])
end



#html отображения для объявлений
get ('/ad/new') do
  erb :new_ad
end

patch ('/ad/edit') do
  erb :edit_ad
end

get ('/ad/show') do
  content_type 'text'
  session['id']
  @ad = Ad.new
  @ad.show_ads()
end

get ('/ad/add') do
  @ad = Ad.new
  if  @ad.add_ad(session['id'], params['lot_id'])
    'Объявление успешно выставленно'
  else
    'Ошибка выставления объявления'
  end
end

get ('/ad/delete') do
  @ad  = Ad.new
  session['id']
  @ad.delete_add(session['id'], params['id'])
end

get ('/ad/show/filter') do
  content_type 'text'
  @ad = Ad.new
  @ad.filter(params['name'], params['price'].to_i, params['count'].to_i)
end

# usert.items
#
# usert.add_item(newItem)




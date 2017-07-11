require 'sequel'
require 'pg'
require 'yaml'
require 'erb'
require 'sinatra'
require 'nokogiri'
require 'rexml/document'
require 'yaml/store'
require 'sequel-pg_array'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

require_relative 'db/Model/ad'
require_relative 'db/Model/lot'
require_relative 'db/Model/item'
require_relative 'db/Model/user'
require_relative 'db/Model/finoperation'

require_relative 'controls/ads_def'
require_relative 'controls/lot_def'
require_relative 'controls/user_def'
require_relative 'controls/item_def'

require_relative 'controls/error'

enable :sessions

get('/') do
  erb :authorization
end

#авторизация
post '/login' do
  @user = User.new
  @user.id  = @user.authorization(params['login'], params['password'])
  if @user.id
    redirect to ('/inventory')
  else
    redirect '/'
  end
end

#инвентарь пользователя
get '/inventory' do
  content_type 'xml'
  @user = User.new
  @xml = @user.get_user_inventory(params['user_id'].to_s)
end

#html отображения для лотов
get ('/lot/return') do
  content_type 'xml'
  @lot = Lot.new
  @xml = @lot.return_lot(params['lot_id'].to_s, params['user_id'].to_s)
  @xml
end

get ('/lot/show') do
  content_type 'xml'
  @lot = Lot.new

    @xml = @lot.get_user_lots(params['user_id'].to_s)
  # else
   # @xml = @lot.get_user_lots(session['id'])
  @xml
end

get ('/lot/add') do
  @lot=Lot.new

  if (params['user_id']!=nil && params[:item_id]!=nil && params[:price]!=nil && params[:count_lot]!=nil)
    if @lot.create_new_lot(params['user_id'], params[:item_id], params[:price], params[:count_lot])
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

  if @lot.buy_lot(params['lot_id'].to_i, params['count'].to_i, params['user_id'])
    'Товар успешно приобретен'
  else
    'Ошибка покупки товара'
  end

end


get ('/lot/delete') do
  @lot = Lot.new
  @lot.delete_lot(params['id'], params['user_id'])
end



#html отображения для объявлений
get ('/ad/new') do
  erb :new_ad
end

get ('/ad/show') do
  content_type 'xml'
  session['id']
  @ad = Ad.new
  @ad.show_ads()
end

get ('/ad/add') do
  @ad = Ad.new
  if  @ad.add_ad(params['user_id'], params['lot_id'])
    'Объявление успешно выставленно'
  else
    'Ошибка выставления объявления'
  end
end

get ('/ad/delete') do
  @ad  = Ad.new

  @ad.delete_add(params['user_id'], params['ad_id'])
end

get ('/ad/show/filter') do
  content_type 'xml'
  @ad = Ad.new
  erb @ad.filter(params['name'], params['price'], params['count'])
end

# usert.items
#
# usert.add_item(newItem)




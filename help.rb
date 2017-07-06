require 'pg'
require 'sequel'
require 'yaml'
require 'erb'
require 'benchmark'
require 'thread'
require 'sequel/plugins/serialization'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

DB.extension :pg_array

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

# ----- КОМАНДЫ ТЕРМИНАЛА -----
# sequel -e production -m db/migrations/ db/config/database.yml - запуск миграций
# psql -h localhost market_db admin - подключение к БД через терминал
# /dt - посмотреть все таблицы БД
# select * from users; - посмотреть все данные таблицы 'users'
# drop table users; - удалить таблицу 'users'
# rvm @global do gem install 'name' - чёткая установка гема для пацанчиков
# alter sequence test_id_seq restart;
# select setval('test_id_seq', 1, false);
# sequel -e production -m db/migrations/ db/config/database.yml

# ----- СОЗДАНИЕ ЭКЗЕМПЛЯРОВ ТАБЛИЦ БД -----
# user=DB[:users]
# item=ItemYml.new
# ad=DB[:ads]
# lot=DB[:lots]

# ----- ВСТАВКА ЗАПИСИ -----
# Item.insert(:name => "Kiwi", :countItem => 3, :user_id => 1) - добавление записи в таблицу 'items'

# ----- УДАЛЕНИЕ ЗАПИСИ -----
# ItemYml.where(:name => 'Kiwi').delete - удалениеие записи из таблицы 'items' с именем 'Kiwi'

# ----- ПОЛУЧЕНИЕ ЗАПИСЕЙ -----
# p ItemYml.all - возвращает все записи таблицы 'items' в виде хэшей
# ItemYml.each{|row| p row} - возвращает все записи 'items' в виде хэшей по строкам
# ItemYml.where(:name => 'Apple').each{|post| p post} - возвращает записи 'items' только с параметром :name => 'Apple'
# p ItemYml.first - возвращает первую запись таблицы 'items'
# p ItemYml.last - возвращает последнюю запись таблицы 'items'
# p ItemYml[:name] => 'Apple']- возвращает определенную запись из таблицы 'users'
# p ItemYml.map(:name) - возвращает все записи :name таблицы 'items'

# ----- ФИЛЬТРАЦИЯ ЗАПИСЕЙ -----
# ItemYml.where(:name => 'Apple', :id => 1) - обычный фильтр по 2-ум параметрам
# p ItemYml.where(:id => 1 .. 2) - фильтр с указанием параметров в виде интервала
# p ItemYml.where(:id => [1, 3]) - фильтр с указанием параметров в виде массива данных
# p ItemYml.where {id > 1} - фильтр с указанием параметра в виде выражения
# ItemYml.where ('name NOT NULL') - наверное фильтр всех непустых записей 'name'

# ----- ПОДВЕДЕНИЕ ИТОГОВ -----
# p ItemYml.max(:id) - возвращает макс/мин(.min) значение (работает и на строки)
# p ItemYml.sum(:id) - возвращает сумму всех 'id'
# p avg = ItemYml.avg(:id) - возвращает среднее значение всех 'id'
# p ItemYml.count - возвращает кол-во записей в таблице 'items'

# ----- СОРТИРОВКА ЗАПИСЕЙ -----
# p ItemYml.order(:id) - сортировка записей по 'id'
# p ItemYml.order(:id).order_append(:name) - сортировка записей по 'id', затем по 'name'
# p ItemYml.order(:id).order_prepend(:name) - сортировка записей по 'name', затем по 'id'
# p ItemYml.reverse_order(:id) # сортировка в убывающем порядке

# ----- ВЫБОР СТОЛБЦОВ -----
# p ItemYml.select(:id) - выбор только 'id' столбца 'items'
# p ItemYml.select(:id).select(:name) - не очень понял что это, но кажется второй 'select' это типа 'where'
# p ItemYml.select(:id, :name) - выбор столбцов 'id', и 'name'
# p ItemYml.select(:id).select_append(:name) - тоже самое, что ItemYml.select(:id, :name), только иначе

# ----- ОБНОВЛЕНИЕ ЗАПИСИ -----
# ItemYml.where(:name => 'Apple').update(:countItem => 7) - обновляет первой записи с параметром :name => 'Apple', обновляя их 'countItem' => 7
# ItemYml.where{|o| o.id < 3}.update(:countItem => 2) - обновление записей с параметром id<3

# ----- ОБРАЗЦЫ ЭКЗЕМПЛЯРОВ -----
# item = ItemYml[1] - создание экземпляра 'item', который равен записи таблицы 'items' со значением :id => 1
# p item.values - выводит все параметры в виде хэша
# p item.name - выводит 'name' (аналогично можно вывести любой другой параметр)
# p item[:name] = 'Maraco' - изменяет какой-либо параметр (не в БД, а лишь в экземпляре! чтобы сохранить изменения в БД, смотри ниже...)
# p item.save - сохраняет данные из экземпляра в БД
# item.set(:name => 'name', :countItem => 1000, :user_id => 2) - изменяет сразу несколько параметров (не в БД, а лишь в экземпляре!)
# item.update(:name => 'Apple', :countItem => 7, :user_id => 1) - изменяет сразу несколько параметров как в экземпляре, так и в БД
# item = ItemYml.create(:name => 'Test') - создаёт запись в БД и экземпляр типа 'items' с параметром :name => 'Test' (остальные параметры => nil)

# ----- АССОЦИАЦИИ -----
# ---------------------------------------------------
# item = ItemYml.new - создание экземпляра модели 'ItemYml'
# item.set(:name => 'name', :countItem => 1000) - задаём параметры для экземпляра (без user_id)
# item.user = User[:id => 1] - связываем 'user_id' с моделью User с параметром :id => 1
# item.save
# ---------------------------------------------------

# item.albums # array of albums
# album.artist # Artist instance or nil
#
# artist.add_album(album) # associate album to artist
# artist.remove_album(album) # disassociate album from artist
# artist.remove_all_albums # disassociate all albums from artist

# ItemYml.each{|row| p row} - возвращает все записи 'items' в виде хэшей по строкам
# ItemYml.where(:name => 'Apple').each{|post| p post} - возвращает записи 'items' только с параметром :name => 'Apple'

# User.association_join(:items).each {|row| p row}

# store = YAML::Store.new('config.yml')

# xml = Builder::XmlMarkup.new( :target => $stdout, :indent => 2 )
#
# xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
#
# xml.inventory {
#   Item.where(:user_id => 1).each do |item|
#     xml.item(:name => store[item.item_id - 1].name, :count => item.count_item, :cost => store[item.item_id - 1].cost)
#   end
# }

# n = 1000
# Benchmark.bm do |x|
#   x.report { n.times do
#     user_sell =  User[:id => 1]
#     user_sell.update(:money => user_sell.money + 0 * 1)
#   end }
# end
#
# n = 1000
# Benchmark.bm do |x|
#   x.report { n.times do
#     User[:id => 1].update(:money => User[:id => 1].money + 0 * 1)
#   end }
# end

# n = 1
# Benchmark.bm do |x|
#   x.report { n.times do
#     item_id = 12
#     user_id = 1
#     count = 1
#     item = Item[:user_id => user_id, :item_id => item_id]
#     item.update(:count_item => item.count_item - count)
#   end }
# end

#{ 'здесь был Вася' }

# Item.where(:user_id => 1).each do |item|
#   p store[item.item_id].name
#   p item.count_item
#   p store[item.item_id].cost
# end

# @i = 1
# begin
#   Lot.insert(:count_lot => rand(1..10), :price => rand(1..100), :user_id => 2, :item_id => @i, :ad_id => @i )
#   @i = @i + 1
# end while @i < 5

# @i = 1
# begin
#   Item.insert(:item_id => @i, :count_item => rand(1..20), :user_id => 1)
#   @i = @i + 1
# end while @i < 15

def test_buy_lot(user_id, lot_id, count) # покупка из лота

  lot = Lot[:id => lot_id] # lot = лоту, в котором происходит покупка

  time_now = Time.now.to_f.divmod 1

  lot.time.push(time_now)
  lot.save

  # 100.times do |i|
  #
  #   if time_now == lot.time.min
  #     break
  #   elsif i == 99
  #     p lot.time.min
  #     return
  #   end
  #
  # end

  if count <= lot.count_lot && lot.user_id != user_id # если покупаемое кол-во предмета из лота <= кол-ву этого предмета && покупку совершает не тот пользователь, который выставил лот, то
    if count != lot.count_lot # если покупаемое кол-во предмета из лота меньше кол-ву этого предмета из лота, то
      lot.update(:count_lot => lot.count_lot - count) # обновляем кол-во предметов в лоте
    else
      lot.delete # иначе удаляем лот, ибо кол-ву предметов будет равно 0
    end
    user_buy = User[:id => user_id] # user_buy = записи юзера, который покупает лот
    user_sell =  User[:id => lot.user_id] # user_sell = записи юзера, который продает лот
    user_sell.update(:money => user_sell.money + lot.price * count) # прибавляем бабосики продавцу
    user_buy.update(:money => user_buy.money - lot.price * count) # вычитаем бабосики покупателя
    item_buy = Item[:item_id => lot.item_id, :user_id => user_buy.id] # item_buy = предмету, который купил покупатель, если такого предмета нет, то = nil
    if item_buy # если предмет есть в инвентаре покупателя, то
      item_buy.update(:count_item => item_buy.count_item + count) # увеличиваем кол-во этого предмета
    else
      Item.insert(:item_id => lot.item_id, :count_item => count, :user_id => user_id) # иначе добавляем предмет покупателю в инвентарь
    end
  end
  # иначе покупаемое кол-во предмета из лота больше кол-ву этого предмета в лоте, а значит покупка не произойдет

end

threads = []

threads << Thread.new do
  test_buy_lot(2, 1, 2)
end

threads << Thread.new do
  sleep 0.001
  test_buy_lot(3, 1, 2)
end

threads << Thread.new do
  sleep 0.002
  test_buy_lot(4, 1, 2)
end

threads.each {|t| t.join}


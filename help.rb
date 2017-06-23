# ----- КОМАНДЫ ТЕРМИНАЛА -----
# sequel -e production -m db/migrations/ db/config/database.yml - запуск миграций
# psql -h localhost market_db admin - подключение к БД через терминал
# /dt - посмотреть все таблицы БД
# select * from users; - посмотреть все данные таблицы 'users'
# drop table users; - удалить таблицу 'users'

# ----- ПОДКЛЮЧЕНИЕ НЕОБХОДИМЫХ БИБЛИОТЕК -----
require 'sequel'
require 'pg'
require 'yaml'
require 'erb'

# ----- ПОДКЛЮЧЕНИЕ К БД -----
DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

# ----- ДОБАВЛЕНИЕ МОДУЛЕЙ -----
require_relative 'db/models/ad'
require_relative 'db/models/lot'
require_relative 'db/models/item'
require_relative 'db/models/user'

# ----- СОЗДАНИЕ ЭКЗЕМПЛЯРОВ ТАБЛИЦ БД -----
# user=DB[:users]
# item=Item.new
# ad=DB[:ads]
# lot=DB[:lots]

# ----- ВСТАВКА ЗАПИСИ -----
# Item.insert(:name => "Kiwi", :countItem => 3, :user_id => 1) - добавление записи в таблицу 'items'

# ----- УДАЛЕНИЕ ЗАПИСИ -----
# Item.where(:name => 'Kiwi').delete - удалениеие записи из таблицы 'items' с именем 'Kiwi'

# ----- ПОЛУЧЕНИЕ ЗАПИСЕЙ -----
# p Item.all - возвращает все записи таблицы 'items' в виде хэшей
# Item.each{|row| p row} - возвращает все записи 'items' в виде хэшей по строкам
# Item.where(:name => 'Apple').each{|post| p post} - возвращает записи 'items' только с параметром :name => 'Apple'
# p Item.first - возвращает первую запись таблицы 'items'
# p Item.last - возвращает последнюю запись таблицы 'items'
# p Item[:name => 'Apple']- возвращает определенную запись из таблицы 'users'
# p Item.map(:name) - возвращает все записи :name таблицы 'items'

# ----- ФИЛЬТРАЦИЯ ЗАПИСЕЙ -----
# Item.where(:name => 'Apple', :id => 1) - обычный фильтр по 2-ум параметрам
# p Item.where(:id => 1 .. 2) - фильтр с указанием параметров в виде интервала
# p Item.where(:id => [1, 3]) - фильтр с указанием параметров в виде массива данных
# p Item.where {id > 1} - фильтр с указанием параметра в виде выражения
# Item.where ('name NOT NULL') - наверное фильтр всех непустых записей 'name'

# ----- ПОДВЕДЕНИЕ ИТОГОВ -----
# p Item.max(:id) - возвращает макс/мин(.min) значение (работает и на строки)
# p Item.sum(:id) - возвращает сумму всех 'id'
# p avg = Item.avg(:id) - возвращает среднее значение всех 'id'
# p Item.count - возвращает кол-во записей в таблице 'items'

# ----- СОРТИРОВКА ЗАПИСЕЙ -----
# p Item.order(:id) - сортировка записей по 'id'
# p Item.order(:id).order_append(:name) - сортировка записей по 'id', затем по 'name'
# p Item.order(:id).order_prepend(:name) - сортировка записей по 'name', затем по 'id'
# p Item.reverse_order(:id) # сортировка в убывающем порядке

# ----- ВЫБОР СТОЛБЦОВ -----
# p Item.select(:id) - выбор только 'id' столбца 'items'
# p Item.select(:id).select(:name) - не очень понял что это, но кажется второй 'select' это типа 'where'
# p Item.select(:id, :name) - выбор столбцов 'id', и 'name'
# p Item.select(:id).select_append(:name) - тоже самое, что Item.select(:id, :name), только иначе

# ----- ОБНОВЛЕНИЕ ЗАПИСИ -----
# Item.where(:name => 'Apple').update(:countItem => 7) - обновляет первой записи с параметром :name => 'Apple', обновляя их 'countItem' => 7
# Item.where{|o| o.id < 3}.update(:countItem => 2) - обновление записей с параметром id<3

# ----- ОБРАЗЦЫ ЭКЗЕМПЛЯРОВ -----
# item = Item[1] - создание экземпляра 'item', который равен записи таблицы 'items' со значением :id => 1
# p item.values - выводит все параметры в виде хэша
# p item.name - выводит 'name' (аналогично можно вывести любой другой параметр)
# p item[:name] = 'Maraco' - изменяет какой-либо параметр (не в БД, а лишь в экземпляре! чтобы сохранить изменения в БД, смотри ниже...)
# p item.save - сохраняет данные из экземпляра в БД
# item.set(:name => 'name', :countItem => 1000, :user_id => 2) - изменяет сразу несколько параметров (не в БД, а лишь в экземпляре!)
# item.update(:name => 'Apple', :countItem => 7, :user_id => 1) - изменяет сразу несколько параметров как в экземпляре, так и в БД
# item = Item.create(:name => 'Test') - создаёт запись в БД и экземпляр типа 'items' с параметром :name => 'Test' (остальные параметры => nil)

# ----- АССОЦИАЦИИ -----
# ---------------------------------------------------
# item = Item.new - создание экземпляра модели 'Item'
# item.set(:name => 'name', :countItem => 1000) - задаём параметры для экземпляра (без user_id)
# item.user = User[:id => 1] - связываем 'user_id' с моделью User с параметром :id => 1
# item.save
# ---------------------------------------------------

# item. # array of albums
# album.artist # Artist instance or nil
#
# artist.add_album(album) # associate album to artist
# artist.remove_album(album) # disassociate album from artist
# artist.remove_all_albums # disassociate all albums from artist

# Item.each{|row| p row} - возвращает все записи 'items' в виде хэшей по строкам
# Item.where(:name => 'Apple').each{|post| p post} - возвращает записи 'items' только с параметром :name => 'Apple'

# User.association_join(:items).each {|row| p row}



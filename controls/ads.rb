def show_ads

  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"ads\"><ads>"
  Ad.each do |ad|
    xml << "<ad id=\"#{ad.id}\" user_id=\"#{ad.user_id}\" description=\"#{ad.description}\" lot_id=\"#{ad.lot_id}\"/>"
  end
  xml << "</ads></information>"

end

def delete_ad(ad_id) # удаление объявления

  Ad[ad_id].delete
  Lot[:ad_id => ad_id].update(:ad_id => nil)

end

def add_ad(store, user_id, lot_id) # добавление объявления

  user = User[:id => user_id] # user = пользователю, который добавляет объявление
  lot = Lot[:id => lot_id] # lot = лоту, к которому добавляется объявление
  ad = Ad.create(:user_id => user.id, :description => "Sold item '#{store[lot.item_id].name}' х #{lot.count_lot} pieces at a price of #{lot.price} coins apiece", :lot_id => lot_id) # ad = объявлению + добавление этого объявления
  lot.update(:ad_id => ad.id) # обновляем лот (добавляем к нему id объявления)
  user.update(:money => user.money - 10) # вычитаем деньги у пользователя за объявление

end

def filter_ads(name, count, price) # фильтр объявлений

  ads_id = []
  filter = DB[:lots].join_table(:inner, DB[:ads], :id => :ad_id) # filter = объединение таблиц объявлений и лотов
  if name # если был введен параметр name, то сортируем по нему
    filter.each do |r|
      index = r.fetch(:description).index("'", 11) - 1
      if r.fetch(:description)[11..index ] == name && r.fetch(:ad_id) != nil
        ads_id << r.fetch(:ad_id)
      end
    end
    filter = filter.where(:ad_id => ads_id)
  end
  if count # если был введен параметр count, то сортируем по нему
    filter = filter.where(:count_lot => count)
  end
  if price # если был введен параметр price, то сортируем по нему
    filter = filter.where(:price => price)
  end
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"ads\"><data><name>#{name}</name><count>#{count}</count><price>#{price}</price></data><message>Filtering was successful.</message><ads>"
  filter.each do |ad|
    xml << "<ad id=\"#{ad.fetch(:id)}\" user_id=\"#{ad.fetch(:user_id)}\" description=\"#{ad.fetch(:description)}\" lot_id=\"#{ad.fetch(:lot_id)}\"/>"
  end
  xml << "</ads></information>"

end

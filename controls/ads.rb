def show_ads

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
  Ad.each do |ad|
    xml << "  <id=\"#{ad.id}\" user_id=\"#{ad.name}\" description=\"#{ad.description}\">\n"
  end
  xml << "</ads>"

end

def delete_ad(user_id, add_id) # удаление объявления

  if user_id == User[:id => Ad[:id => add_id].name].id # если id пользователя, который хочет удалить объявление, равен id тому, кто объявление выставил, то
    Lot[:ad_id => add_id].update(:ad_id => nil) # обнуляем ad_id у лота, к которому было привязано объявление
    Ad[:id => add_id].delete # удаляем объявление
  end

end

def new_ad(user, lot, description, lot_id) # создание нового объявления

  ad = Ad.create(:name => user.id, :description => description, :lot_id => lot_id) # ad = объявлению + добавление этого объявления
  lot.update(:ad_id => ad.id) # обновляем лот (добавляем к нему id объявления)
  user.update(:money => user.money - 5) # вычитаем деньги у пользователя за объявление

end

def add_ad(store, user_id, lot_id) # добавление объявления

  user = User[:id => user_id] # user = пользователю, который добавляет объявление
  if user.money >= 5 # если у пользователя достаточно денег чтобы выставить объявление, то
    lot = Lot[:id => lot_id, :user_id => user_id] # lot = лоту, к которому добавляется объявление
    if !lot.ad_id # и если у лота нет объявления, то
      new_ad(user, lot, "Продаётся предмет \"#{store[lot.item_id].name}\" х #{lot.count_lot} шт. по цене #{lot.price} за штуку", lot_id) # создание нового объявления
    else # иначе у лота есть объявление, а значит мы его редактируем
      delete_ad(user_id, lot.ad_id) # удаляем объявление, которое было
      new_ad(user, lot, "Продаётся предмет \"#{store[lot.item_id].name}\" х #{lot.count_lot} шт. по цене #{lot.price} за штуку", lot_id) # создание нового объявления
    end
  end

end

def filter_ads(name, count, price) # фильтр объявлений

  filter = DB[:lots].join_table(:inner, DB[:ads], :id => :ad_id) # filter = объединение таблиц объявлений и лотов
  if name # если был введен параметр name, то сортируем по нему
    filter = filter.where(Sequel.like(:description, "%#{name}%"))
  end
  if count # если был введен параметр count, то сортируем по нему
    filter = filter.where(:count_lot => count)
  end
  if price # если был введен параметр price, то сортируем по нему
    filter = filter.where(:price => price)
  end
  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
  filter.each do |ad|
    xml << "  <id=\"#{ad.fetch(:id)}\" user_id=\"#{ad.fetch(:name)}\" description=\"#{ad.fetch(:description)}\">\n"
  end
  xml << "</ads>"

end

def show_lots(store, user_id, type = "lots", error = "") # отображение лотов

  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"#{type}\">#{error}<user_id>#{user_id}</user_id><market>"
  Lot.where(:user_id => user_id).each do |lot|
    xml << "<lot id=\"#{lot.id}\" name=\"#{store[Item[:item_id => lot.item_id].item_id].name}\" count=\"#{lot.count_lot}\" price=\"#{lot.price}\" ad_id=\"#{lot.ad_id}\"/>"
  end
  xml << "</market></information>"

end

def add_lot(user_id, item_id, count, price) # добавление лота

  lot = Lot.new
  item = Item[:user_id => user_id, :item_id => item_id] # item = предмету, который выставляют в лот
  if count < item.count_item # если выставляемое кол-во в лоте меньше кол-ва этого предмета в инвентаре, то
    lot.set(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id)# добавляем лот
    item.update(:count_item => item.count_item - count) # из кол-ва предмета в инвентаре вычитаем кол-во, которое выложили в лот
  elsif count == item.count_item # иначе, если кол-во в лоте равно кол-ву этого предмета в инвентаре, то
    lot.set(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id) # добавляем лот
    item.delete # предмет из инвентаря удаляем, т.к. его кол-во = 0
  end
  lot.save

end

def buy_lot(user_id, lot_id, count) # покупка из лота

  10.times do
    lot = Lot[:id => lot_id]
    if count <= lot.count_lot
      new_count_item = lot.count_lot - count
      if Lot.where(:id => lot_id, :count_lot => lot.count_lot).update(:count_lot => new_count_item) != 0
        lot = Lot[:id => lot_id]
        user_buy = User[:id => user_id]
        User[:id => lot.user_id].update(:money => User[:id => lot.user_id].money + lot.price * count) # прибавляем бабосики продавцу
        user_buy.update(:money => user_buy.money - lot.price * count) # вычитаем бабосики покупателя
        item_buy = Item[:item_id => lot.item_id, :user_id => user_buy.id] # item_buy = предмету, который купил покупатель, если такого предмета нет, то = nil
        if lot.count_lot == 0
          lot.delete
        end
        if item_buy # если предмет есть в инвентаре покупателя, то
          item_buy.update(:count_item => item_buy.count_item + count) # увеличиваем кол-во этого предмета
        else
          Item.insert(:item_id => lot.item_id, :count_item => count, :user_id => user_id) # иначе добавляем предмет покупателю в инвентарь
        end
      end
    end
  end

end

def return_lot (lot_id) # возврат лота (отмена лота)

  lot = Lot[:id => lot_id] # lot = лоту, который хотим вернуть, если такого лота нет, то = nil
  item = Item[:item_id => lot.item_id, :user_id => lot.user_id] # item = предмету пользователя, который выставлен в лоте, если предмета нет, то = nil
  if item # если предмет есть в инвентаре пользователя, то
    item.update(:count_item => item.count_item + lot.count_lot) # увеличиваем его кол-во на кол-во предмета из инвентаря
  else
    Item.insert(:item_id => lot.item_id, :count_item => lot.count_lot, :user_id => lot.user_id) # иначе добавляем предмет в инвентарь пользователя с кол-вом равным кол-ву лота
  end
  if Lot[:id => lot_id].ad_id # если у лота есть объявление, то
    Ad[:lot_id => lot_id].delete # удаляем это объявление, т.к. лота уже нет
  end
  # иначе у лота нет объявления и мы ничего не удаляем
  lot.delete # после возврата предмета и удаления объявления лота, наконец удаляем сам лот

end
def show_lots store, user_id # отображение лотов

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<lots>\n"
  Lot.where(:user_id => user_id).each do |lot|
    xml << "  <id=\"#{lot.id}\" name=\"#{store[Item[:item_id => lot.item_id].item_id].name}\" count=\"#{lot.count_lot}\" price=\"#{lot.price}\">\n"
  end
  xml << "</lots>"

end

def add_lot user_id, item_id, count, price, count_of_lots # добавление лота

  if Lot.where(:user_id => user_id).count < count_of_lots # если у пользователя кол-во лотов меньше допустимого, то
    item = Item[:user_id => user_id, :item_id => item_id] # item = предмету, который выставляют в лот
    if count < item.count_item # если выставляемое кол-во в лоте меньше кол-ва этого предмета в инвентаре, то
      Lot.insert(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id) # добавляем лот
      item.update(:count_item => item.count_item - count) # из кол-ва предмета в инвентаре вычитаем кол-во, которое выложили в лот
    elsif count == item.count_item # иначе, если кол-во в лоте равно кол-ву этого предмета в инвентаре, то
      Lot.insert(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id) # добавляем лот
      item.delete # предмет из инвентаря удаляем, т.к. его кол-во = 0
    end
    # если не прошли оба условия, то count > item.count_item, а значит лот создавать нельзя
  end
  # иначе достигнуто максимальное кол-во лотов и добавить новый лот нельзя
end

def buy_lot(user_id, lot_id, count) # покупка из лота

  number = 0
  lot = Lot[:id => lot_id] # lot = лоту, в котором происходит покупка

  while lot.time do
    number = number + 1
    if number == 100
      return
    end
  end

  lot.update(:time => Time.now.to_f) # устанавливаем время покупки

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

  lot.update(:time => nil) # обнуляем время покупки

end

def return_lot (user_id, lot_id) # возврат лота (отмена лота)

  lot = Lot[:id => lot_id] # lot = лоту, который хотим вернуть, если такого лота нет, то = nil
  if user_id == lot.user_id # если id пользователя, который хочет вернуть предмет == id пользователя, который выставил лот, то
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
  # иначе возврат лота хочет сделать не тот пользователь, который его выставил, а значит отменяем возврат

end
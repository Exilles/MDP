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

def buy_lot(lot_id, count, user_buyer_id)


  if count =='' && lot_id =='' && user_buyer_id ==''
    return enter_data_error(nil,nil,nil,'buy_lot', '')
  end

  if lot_id=='' && count==''
    return enter_data_error(nil,user_buyer_id,nil, 'buy_lot', '')
  end

  if lot_id == '' && user_buyer_id == ''
    return enter_data_error(nil,nil,count,'buy_lot', '')
  end

  if count =='' && user_buyer_id == ''
    return enter_data_error(lot_id,nil,nil,'buy_lot','')
  end

  if user_buyer_id == ''
    return enter_data_error(lot_id,nil,count,'buy_lot','')
  end

  if count == ''
    return enter_data_error(lot_id,user_buyer_id,nil,'buy_lot','')
  end

  if lot_id == ''
    return enter_data_error(nil,user_buyer_id,count,'buy_lot','')
  end



  if (!(/^[0-9\-_]+$/ =~ user_buyer_id) && !(/^[0-9\-_]+$/ =~ count) && !(/^[0-9\-_]+$/ =~ lot_id))
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','Lot_id contains, Count contains, User_id contains')
  end

  if (!(/^[0-9\-_]+$/ =~ user_buyer_id) && !(/^[0-9\-_]+$/ =~ lot_id))
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','User_id contains, Lot_id contains')
  end

  if (!(/^[0-9\-_]+$/ =~ user_buyer_id) && !(/^[0-9\-_]+$/ =~ count))
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','User_id contains, Count contains')
  end

  if (!(/^[0-9\-_]+$/ =~ count) && !(/^[0-9\-_]+$/ =~ lot_id))
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','Lot_id contains, Count contains')
  end

  if !(/^[0-9\-_]+$/ =~ user_buyer_id)
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','User_id contains')
  end

  if !(/^[0-9\-_]+$/ =~ lot_id)
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','Lot_id contains')
  end

  if !(/^[0-9\-_]+$/ =~ count)
    return enter_data_error(lot_id,user_buyer_id,count,'buy_lot','Count contains')
  end



  if !Lot.where(:id => lot_id).any? #проверка на существование лота
    return enter_data_error(lot_id,user_buyer_id,count, 'buy_lot', 'Lot exists')
  end

  if !User.where(:id => user_buyer_id).any? #проверка на существование пользователя
    return enter_data_error(lot_id,user_buyer_id,count, 'buy_lot', 'User exists')
  end


  lot = Lot[:id => lot_id]

  user_buyer = User[:id => user_buyer_id]
  user_seller = User[:id => lot.user_id]

  if user_buyer_id.to_i == user_seller.id
    return enter_data_error(lot_id,user_buyer_id,count, 'buy_lot', 'Same user')
  end

  lot_price = lot.price
  lot_item_id = lot.item_id

  if user_buyer.money - lot_price*count.to_i>=0 #проверка на наличие нужной суммы денег у продавца

    200.times do #цикл для попытки купить товар

      lot = Lot[:id => lot_id]
      lot_count  = lot.count_lot - count.to_i

      if count.to_i <= lot.count_lot

        #проверка на количество покупаемых предметов

        # operation_time = DB[:finoperations].min(:operation_time)

        # if operation_time == time_for_base.to_i #проверям совпадает ли минимальное время операции с временем покупки пользователя

        #Thread.new do # распределение потоков, для предотвращения одновременной покупки предметов
        #mutex.synchronize do

        if Lot.where(:id => lot_id, :count_lot => lot.count_lot).update(:count_lot => lot_count)!=0  #lot.update(:count_lot => lot.count_lot - count)#обновление количества предметов в лоте



          if lot_count == 0 #проверка на наличия предметов в лоте после успешной покупки
            Ad.where(:lot_id => lot.id).delete #удаление объявление, если товара в лоте больше нет
            lot.delete #удаление лота по той же причине
          end

          user_seller.update(:money => user_seller.money + lot_price * count.to_i) #обновление суммы денег у продавца
          user_buyer.update(:money => user_buyer.money - lot_price * count.to_i) #обновление суммы денег у покупателя
          item = Item[:item_id => lot_item_id, :user_id => user_buyer_id]

          if item #проверка на наличие предмета такого же типа у покупателя в инвентаре

            item.update(:count_item => item.count_item + count.to_i)
            #если есть, то прибавляем количество купленных предметов
          else
            Item.insert(:item_id => lot_item_id, :count_item => count, :user_id => user_buyer.id)
            #если нет, то создаем новую запись
          end

          return success_buy_items_message(user_buyer_id, lot_id,count)

        end
        # end



        # else
        #   lot = Lot[:id => lot_id]
        #
        #    if !lot
        #     return false
        #    end

        # end # конец условия на совпадение минимального времени операции с временем покупки пользователя

      else


        return having_lot_items_error(user_buyer_id, lot_id, count)

      end #конец условия на проверку количество покупаемых предметов

    end #конец цикла попыток для совершения покупок

    return timeout_exceeded_message(user_buyer_id, lot_id, count)

  else
    having_money_error(user_buyer_id,lot_id, user_buyer.money, count)
  end #конец условия проверка на наличие нужной суммы денег у продавца



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
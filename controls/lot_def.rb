

class Lot

  def get_user_lots(id)

    if id != ''

      if (/^[0-9\-_]+$/ =~ id)

        if User.where(:id => id).any?


          all_items = Item.new('item.yml').all

        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<lots>\n"
         Lot.where(:user_id => id).each do |lot|
          xml << "  <lot name=\"#{all_items[lot.item_id].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\"/>\n"
         end
         xml << "</lots>"

        else
          enter_data_error(0,id,0, 'lot', 'User exists')
        end
      else
        enter_data_error(0, id, 0,'lot','User_id contains')
      end
    else
      enter_data_error(0,id,0,'lot', '')
    end
      #вариант через Nokogiri
      # Nokogiri::XML::Builder.new {|xml|
      #   xml.lots "Lots" do
      #     Lot.where(:user_id => 1).each do |userlot|
      #       xml.lot :price => userlot.price, :count => userlot.count_lot
      #     end
      #   end
      # }.to_xml

  end

  def create_new_lot(user_id, item_id, price, count_lot)
    all_items = Item.new('item.yml').all
    item = Item[:id => item_id, :user_id=> user_id]
    lot = Lot.where(:user_id => user_id)
    if item.count_item.to_i - count_lot.to_i >= 0 && count_lot.to_i<=10 && lot.count <= all_items[0].cost.to_i

     Lot.insert(:price => price, :count_lot => count_lot, :user_id=>user_id , :item_id => item.item_id)
     item.update(:count_item => item.count_item.to_i - count_lot.to_i)

      if (item.count_item == 0)
        item.delete
      end

      return true
    else
      return false
    end
  end

  def delete_lot(id, user_id)
    Lot.where(:id => id).delete
    Item.where(:user_id => user_id, :id => Lot[:id => id].item_id).delete
  end

  def return_lot (lot_id, user_id)

    if lot_id == '' && user_id==''
     return enter_data_error(nil, nil,0, 'return_lot','')
    end

    if lot_id == '' #проверка на ввод id лота
     return enter_data_error(nil, user_id,0, 'return_lot','')
    end #конец условия на проверку ввода лота

    if user_id== ''  #проверка на ввод id пользователя
      return  enter_data_error(lot_id,nil,0,'return_lot','')
    end #конец проверки на ввод id пользователя

    if (!(/^[0-9\-_]+$/ =~ lot_id) && !(/^[0-9\-_]+$/ =~ user_id))
      return enter_data_error(lot_id, user_id,0,'return_lot','Lot_id contains, User_id contains')
    end

    if !(/^[0-9\-_]+$/ =~ lot_id) #проверка на корректность введенных данных в id лота
     return enter_data_error(lot_id, user_id,0,'return_lot','Lot_id contains')
    end #конец проверки на корректность введенных данных в id лота

    if !(/^[0-9\-_]+$/ =~ user_id) #проверка на корректность введенных данных в id пользователя
     return enter_data_error(lot_id, user_id,0, 'return_lot', 'User_id contains')
    end #конец проверки на корректность введенных данных в id пользователя


    if !Lot.where(:id => lot_id).any? #проверка на существование лота
      return enter_data_error(lot_id,user_id,0, 'return_lot', 'Lot exists')
    end #конец проверки на сущестование лота

    if !User.where(:id => user_id).any? #проверка на существоание пользователя
     return enter_data_error(lot_id,user_id,0, 'return_lot', 'User exists')
    end #конец проверки на сущетвование пользователя

    if !Lot.where(:id => lot_id, :user_id => user_id).any? #проверка есть ли у пользователя такой лот
      return having_error(user_id,lot_id)
    end


    lot = Lot[:id => lot_id]

    if Item.where(:user_id => user_id, :item_id => lot.item_id).any?

      item = Item[:user_id => user_id, :item_id => lot.item_id]
      item.update(:count_item => item.count_item.to_i + lot.count_lot.to_i)

    else
      Item.insert(:count_item => lot.count_lot.to_i, :item_id => lot.item_id, :user_id => lot.user_id)
    end

    xml = success_return_lot_message(lot)

    lot.delete

    return xml


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
    # time_update = Time.new #вариант со временем
    #
    # if time_update.month < 10
    #   time_for_base = time_update.month.to_s + time_update.day.to_s + time_update.hour.to_s + time_update.min.to_s + time_update.sec.to_s + time_update.usec.to_s
    #  else
    #   time_for_base = time_update.month.to_s + time_update.day.to_s + time_update.hour.to_s + time_update.min.to_s + time_update.sec.to_s + time_update.usec.to_s
    # end
    #
    # Finoperation.insert(:user_buyer_id => user_buyer_id, :lot_id => lot_id, :operation_time => time_for_base.to_i)

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

end


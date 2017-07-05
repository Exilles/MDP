

class Lot

  def get_user_lots(id)

     all_items = Item.new('item.yml').all

     xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n" + "<lots>\n"
     Lot.where(:user_id => id).each do |lot|
      xml << "  <lot name=\"#{all_items[lot.item_id].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\" >\n"
     end
     xml << "</lots>"


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

  def return_lot (id, user_id)

    lot = Lot[:id => id]
    if Item.where(:user_id => user_id, :item_id => lot.item_id).any?
     item = Item[:user_id => user_id, :item_id => lot.item_id]
     item.update(:count_item => item.count_item.to_i + lot.count_lot.to_i)
     lot.delete
    else
      Item.insert(:count_item => lot.count_lot.to_i, :item_id => lot.item_id, :user_id => lot.user_id)
      lot.delete
    end
  end

  def buy_lot(lot_id, count, user_buyer_id)


    lot = Lot[:id => lot_id]

    lot.update(:update_time => nil)
    user_buyer = User[:id => user_buyer_id]
    user_seller = User[:id => lot.user_id]
    i=0

    if count <= lot.count_lot && lot.user_id != user_buyer_id && user_buyer.money - lot.price*count>=0

      #проверка на количество покупаемых предметов и продавца и на наличие нужной суммы денег у продавца

      time_update = Time.new #вариант со временем

      if time_update.month < 10
        time_for_base = time_update.year.to_s + '0' + time_update.month.to_s + time_update.day.to_s + time_update.hour.to_s + time_update.min.to_s + time_update.sec.to_s + time_update.usec.to_s
       else
        time_for_base = time_update.year.to_s + time_update.month.to_s + time_update.day.to_s + time_update.hour.to_s + time_update.min.to_s + time_update.sec.to_s + time_update.usec.to_s
      end

      # while i<10 do #цикл для попытки купить этот товар

        if lot.update_time == nil #смотрим успрел ли кто-то начать покупку этого товара раньше
           Lot.insert(:update_time => time_for_base.to_i, :user_id => user_buyer_id, :count_lot => count)

          # puts lot.update_time
        # end

          p = DB[:lots].min(:update_time)
         if  p == time_for_base.to_i
           puts lot_id
           puts count
           puts user_buyer_id
          #Thread.new do # распределение потоков, для предотвращения одновременной покупки предметов
          #mutex.synchronize do

    #       user_seller.update(:money => User[:id => lot.user_id].money + lot.price * count) #обновление суммы денег у продавца
    #       user_buyer.update(:money => user_buyer.money - lot.price * count) #обновление суммы денег у покупателя
    #       item = Item[:item_id => lot.item_id, :user_id => user_buyer_id]
    #
    #       if item #проверка на наличие предмета такого де типа у покупателя в инвентаре
    #         item.update(:count_item => item.count_item + count)
    #         #если есть, то прибавляем количество купленных предметов
    #        else
    #         Item.insert(:item_id => lot.item_id, :count_item => count, :user_id => user_buyer.id)
    #         #если нет, то создаем новую запись
    #       end
    #
    #       if lot.count_lot - count == 0
    #         Ad.where(:lot_id => lot.id).delete #удаление объявление, если товара в лоте больше нет
    #         lot.delete #удаление лота по той же причине
    #        else
    #         lot.update(:count_lot => lot.count_lot - count, :update_time => nil)
    #       end
    #
    #
    #
    #       #end
    #       #end
    #
    #       return true
    #
    #      else
    #
    #       i+=1
    #       if !Lot.where(:id => lot_id).any? #проверка на сущестование предмета во время одновременной покупки
    #         return false
    #       end
    #
        end

      end

    #   return false
    #
    # else

      # return false

     end


  end

end

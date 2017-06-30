

class Lot

  def get_user_lots(id)

     all_items = Item.new('item.yml').all

     xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n" + "<lots>\n"
     Lot.where(:user_id => id).each do |lot|
      xml << "  <lot name=\"#{all_items[Item[:id => lot.item_id].item_id - 1].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\" >\n"
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
    if Item[:id => item_id, :user_id=> user_id].count_item.to_i - count_lot.to_i >= 0 && count_lot<=10
     Lot.insert(:price => price, :count_lot => count_lot, :user_id=>user_id , :item_id => item_id)
     Item.where(:id => item_id, :user_id=> user_id).update(:count_item => Item[:id => item_id, :user_id=> user_id].count_item.to_i - count_lot.to_i)
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
    Item.where(:user_id => user_id, :id => lot.item_id).update(:count_item => Item[:user_id => user_id, :id => lot.item_id].count_item.to_i + lot.count_lot.to_i)
    Lot.where(:id => id).delete

  end

  def buy_lot(lot_id, count, user_buyer_id)
    lot = Lot[:id => lot_id]

    if count <= lot.count_lot && lot.user_id != user_buyer_id #проверка на количество покупаемых предметов и продавца

        if lot.count_lot - count == 0
          lot.delete
        else
          lot.update(:count_lot => lot.count_lot - count)
        end

      user = User[:id => user_buyer_id]
      User[:id => lot.user_id].update(:money => User[:id => lot.user_id].money + lot.price * count) #обновление суммы денег у продавца
      user.update(:money => user.money - lot.price * count) #обновление суммы денег у покупателя


      item_config_id = Item[:id => lot.item_id, :user_id => lot.user_id].item_id

        if Item.where(:item_id => item_config_id, :user_id => user_buyer_id).any? #проверка на наличие предмета такого де типа у покупателя в инвентаре
          Item.where(:item_id => item_config_id, :user_id => user_buyer_id).update(:count_item => Item[:item_id => item_config_id, :user_id => user_buyer_id].count_item + count)
          #если есть, то прибавляем количество купленных предметов
        else
          Item.insert(:item_id => item_config_id, :count_item => count, :user_id => lot.user_id)
          #если нет, то создаем новую запись
        end

      return true
    else
      return false
    end


  end

end

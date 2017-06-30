def show_lots(store, id)

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<lots>\n"
  Lot.where(:user_id => id).each do |lot|
    xml << "  <id=\"#{lot.id}\" name=\"#{store[Item[:id => lot.item_id].item_id - 1].name}\" count=\"#{lot.count_lot}\" price=\"#{lot.price}\">\n"
  end
  xml << "</lots>"

end

def add_lot(user_id, item_id, count, price)

  item = Item[:user_id => user_id, :item_id => item_id]
  if count < item.count_item
    Lot.insert(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id)
    item.update(:count_item => item.count_item - count)
  elsif count == item.count_item
    Lot.insert(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id)
    item.delete
  end

end

def buy_lot(user_id, lot_id, count)

  lot = Lot[:id => lot_id]
  if count <= lot.count_lot && lot.user_id != user_id
    if count != lot.count_lot
      lot.update(:count_lot => lot.count_lot - count)
    else
      lot.delete
    end
    user_buy = User[:id => user_id]
    user_sell =  User[:id => lot.user_id]
    user_sell.update(:money => user_sell.money + lot.price * count)
    user_buy.update(:money => user_buy.money - lot.price * count)
    item_buy = Item[:item_id => lot.item_id, :user_id => user_buy.id]
    if item_buy
      item_buy.update(:count_item => item_buy.count_item + count)
    else
      Item.insert(:item_id => lot.item_id, :count_item => count, :user_id => user_id)
    end
  end

end

def return_lot (user_id, lot_id)

  lot = Lot[:id => lot_id]
  if user_id == lot.user_id
    item = Item[:id => lot.item_id, :user_id => lot.user_id]
    if item
      item.update(:count_item => item.count_item + lot.count_lot)
    else
      Item.insert(:item_id => lot.item_id, :count_item => lot.count_lot, :user_id => lot.user_id)
    end

    if Lot[:id => lot_id].ad_id
      Ad[:lot_id => lot_id].delete
    end
    lot.delete
  end

end
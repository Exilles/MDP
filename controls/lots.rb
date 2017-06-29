def show_lots(store, id)

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<lots>\n"
  Lot.where(:user_id => id).each do |lot|
    xml << "  <id=\"#{lot.id}\" name=\"#{store[Item[:id => lot.item_id].item_id - 1].name}\" count=\"#{lot.count_lot}\" price=\"#{lot.price}\">\n"
  end
  xml << "</lots>"

end

def add_lot(user_id, item_id, count, price)

  if count <= Item[:user_id => user_id, :item_id => item_id].count_item
    Lot.insert(:count_lot => count, :price => price, :user_id => user_id, :item_id => item_id)
    Item.where(:user_id => user_id, :item_id => item_id).update(:count_item => Item[:user_id => user_id, :item_id => item_id].count_item - count)
    true
  else
    false
  end

end

def delete_lot(id)

  Lot.where(:id => id).delete
  Item.where(:user_id => Lot[:id => id].user_id, :item_id => Lot[:id => id].item_id).delete

end

def return_lot (id)

  Item.where(:user_id => Lot[:id => id].user_id, :item_id => Lot[:id => id].item_id).update(:count_item => Item[:user_id => Lot[:id => id].user_id, :item_id => Lot[:id => id].item_id].count_item + Lot[:id => id].count_lot)
  Lot.where(:id => id).delete

end
def success_return_lot_message(lot)

  all_items = ItemStore.new('config.yml').all
  user = User[:id=>lot.user_id]
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"return_lot\" >"
  xml << "<data><lot_id>#{lot.id}</lot_id><user_id>#{lot.user_id}</user_id><count_lot>#{lot.count_lot}</count_lot><price>#{lot.price}</price></data><message>Lot was successfully returned</message>"
  xml <<"<inventory money=\"#{user.money}\" nickname=\"#{user.login}\" user_id=\"#{lot.user_id}\" >"
  Item.where(:user_id => lot.user_id).each do |item|
    xml << "  <item name=\"#{all_items[item.item_id].name}\" count=\"#{item.count_item}\" price=\"#{all_items[item.item_id - 1].price}\" item_id=\"#{item.id}\"/>\n"
  end
  xml << "</inventory>"
  xml << "</information>"

end

def success_buy_items_message(user_id, lot_id, count)

  all_items = ItemStore.new('config.yml').all
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"buy_lot\" >"
  xml << "<data><lot_id>#{lot_id}</lot_id><user_id>#{user_id}</user_id><count>#{count}</count></data><message>Items were successfully bought</message>"
  xml <<"<inventory money=\"#{User[:id=>user_id].money}\" nickname=\"#{User[:id=>user_id].login}\" user_id=\"#{user_id}\" >"
  Item.where(:user_id => user_id).each do |item|
    xml << "  <item name=\"#{all_items[item.item_id].name}\" count=\"#{item.count_item}\" price=\"#{all_items[item.item_id - 1].price}\" item_id=\"#{item.id}\"/>\n"
  end
  xml << "</inventory>"
  xml << "</information>"

end

def timeout_exceeded_message(user_id, lot_id, count)
  lot = Lot[:id => lot_id]
  all_items = ItemStore.new('config.yml').all
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"buy_lot\" >"
  xml << "<data><lot_id>#{lot_id}</lot_id><user_id>#{user_id}</user_id><count>#{count}</count></data><message>Timeout exceeded</message>"
  xml << "<lot name=\"#{all_items[lot.item_id].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\"/>\n"
  xml << "</information>"
end
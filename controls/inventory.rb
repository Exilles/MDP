def show_inventory(store, user_id, type = "inventory", error = "")

  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"#{type}\">#{error}<user_id>#{user_id}</user_id><coins>#{User[user_id].money}</coins><inventory>"
  Item.where(:user_id => user_id).each do |item|
    xml << "<item id=\"#{store[item.item_id].id}\" name=\"#{store[item.item_id].name}\" count=\"#{item.count_item}\" price=\"#{store[item.item_id].price}\"/>"
  end
  xml << "</inventory></information>"

end
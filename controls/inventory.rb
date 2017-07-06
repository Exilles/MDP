def show_inventory(store, id)

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<inventory money=\"#{User[id].money}\">\n"
  Item.where(:user_id => id).each do |item|
    xml << "  <id=\"#{store[item.item_id].id}\" name=\"#{store[item.item_id].name}\" count=\"#{item.count_item}\" cost=\"#{store[item.item_id].cost}\">\n"
  end
  xml << "</inventory>"

end
def show_inventory(store, id)

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<money=\"#{User[id].money}\">\n<inventory>\n"
  Item.where(:user_id => id).each do |item|
    xml << "  <id=\"#{store[item.item_id - 1].id}\" name=\"#{store[item.item_id - 1].name}\" count=\"#{item.count_item}\" cost=\"#{store[item.item_id - 1].cost}\">\n"
  end
  xml << "</inventory>"

end
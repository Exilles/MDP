def show_inventory(store, id)

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<inventory>\n"
  Item.where(:user_id => id).each do |item|
    xml << "  <id=\"#{item.id}\" name=\"#{store[item.item_id - 1].name}\" count=\"#{item.count_item}\" cost=\"#{store[item.item_id - 1].cost}\">\n"
  end
  xml << "</inventory>"

end



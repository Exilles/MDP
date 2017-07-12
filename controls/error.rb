

# def enter_data_error(id, type, teg, description)
#   xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
#    if (type!=nil && id!=nil)
#     xml << "<data><#{teg}>#{id}</#{teg}></data><errors><error>#{description}</error></errors>"
#    else
#     xml << "<data><user_id></user_id><lot_id></lot_id></data><errors><error>User_id doesn't enter</error><error>Lot_id doesn't enter</error></errors>"
#    end
#   xml << "</information>"
# end

def enter_data_error(lot_id, user_id, count, type, description)

  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
   xml << "<data>"
    xml << "<user_id>#{user_id}</user_id>"
    if lot_id!=0
     xml << "<lot_id>#{lot_id}</lot_id>"
    end
    if count!=0
      xml << "<count>#{count}</count>"
    end
  xml << "</data><errors>"

  if user_id == nil
    xml << "<error>User_id does not enter</error>"
  end

  if lot_id == nil
    xml << "<error>Lot_id does not enter</error>"
  end

  if count == nil
    xml << "<error>Count does not enter</error>"
  end

  if description.include?('User_id contains')
    xml << "<error>User_id contains invalid characters</error>"
  end

  if description.include?('Lot_id contains')
    xml << "<error>Lot_id contains invalid characters</error>"
  end

  if description.include?('Count contains')
    xml << "<error>Count contains invalid characters</error>"
  end

  if  description.include?('User exists')
    xml << "<error>User doesn't exist</error>"
  end

  if  description.include?('Lot exists')
    xml << "<error>Lot doesn't exist</error>"
  end

  if description.include?('Same user')
    xml << "<error>Buyer's and seller's id can not match</error>"
  end

  xml << "</errors>"
  xml << "</information>"
end

def enter_data_contain_error ()

end


# def undefined_enter_id(id,type)
#   xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
#     xml << "<data><user_id>#{id}</user_id></data><errors><error>User_id contains invalid characters</error></errors>"
#   xml << "</information>"
# end
#
# def empty_id(type)
#   xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"#{type}\" >"
#     xml << "<data><user_id/></data><errors><error>User_id doesn't enter</error></errors>"
#   xml << "</information>"
# end

def having_error(user_id, lot_id)
  all_items = Item.new('item.yml').all
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"return_lot\" >"
   xml << "<data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id></data><errors><error>User doesn't have this lot</error></errors>"

  Lot.where(:user_id => user_id).each do |lot|
    xml << "<lots><lot name=\"#{all_items[lot.item_id].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\"/></lots>"
  end

  if Lot[:user_id => user_id]==nil
    xml << "<lots>User doesn't have any lots</lots>"
  end

  xml << "</information>"
end

def having_money_error(user_id, lot_id,money, count)

  all_items = Item.new('item.yml').all
  lot = Lot[:id => lot_id]
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"buy_lot\" >"
   xml << "<data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id><count>#{count}</count></data><errors><error>Not enough money to buy</error></errors>"
   xml << "<money>#{money}</money>"
   xml << "<lot name=\"#{all_items[lot.item_id].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\"/>\n"
  xml << "</information>"

end

def having_lot_items_error(user_id,lot_id,count)

  all_items = Item.new('item.yml').all
  lot = Lot[:id => lot_id]

  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <information type=\"buy_lot\" >"
   xml << "<data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id><count>#{count}</count></data><errors><error>Not enough items to buy</error></errors>"

   xml << "<lot name=\"#{all_items[lot.item_id].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\"/>\n"

  xml << "</information>"


end






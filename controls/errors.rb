def register_valid(login, password)

  error = ""
  error << "<error>Login is too long. A maximum of 15 characters.</error>" if (login.length > 16)
  if login.length == 0
    error << "<error>Enter your login.</error>"
  elsif login.length < 4
    error << "<error>Login is too short. A minimum of 4 characters.</error>"
  end
  if login.length > 0
    error << "<error>Login contains invalid characters.</error>" if !(/^[a-zA-Z0-9\-_]+$/=~login) || login.include?("-") || login.include?("_")
  end
  error << "<error>This login already exists.</error>" if User.where(:login => login).any?
  error << "<error>Password is too long. A maximum of 15 characters.</error>" if (password.length > 16)
  if password.length == 0
    error << "<error>Enter your password.</error>"
  elsif password.length < 4
    error << "<error>Password is too short. A minimum of 4 characters.</error>"
  end
  error << "<error>Password can't contain a space character.</error>" if password.include?(" ")

  if error != ""
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"registration\"><data><login>#{login}</login><password>#{password}</password></data><errors>#{error}</errors></information>"
  else
    registration(login, password)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"registration\"><data><login>#{login}</login><password>#{password}</password></data><message>Account successfully registered!</message></information>"
  end

end

def inventory_valid(user_id, store)

  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id)
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"inventory\"><data><user_id>#{user_id}</user_id></data><errors><error>User id contains invalid characters.</error></errors></information>"
    elsif User.where(:id => user_id.to_i).any?
      show_inventory(store, user_id)
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"inventory\"><data><user_id>#{user_id}</user_id></data><errors><error>User does not exist.</error></errors></information>"
    end
  else
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"inventory\"><data><user_id>#{user_id}</user_id></data><errors><error>Enter the user id.</error></errors></information>"
  end

end

def market_valid(user_id, store)

  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id)
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"market\"><data><user_id>#{user_id}</user_id></data><errors><error>User id contains invalid characters.</error></errors></information>"
    elsif User.where(:id => user_id.to_i).any?
      show_lots(store, user_id)
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"market\"><data><user_id>#{user_id}</user_id></data><errors><error>User does not exist.</error></errors></information>"
    end
  else
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"market\"><data><user_id>#{user_id}</user_id></data><errors><error>Enter the user id.</error></errors></information>"
  end

end

def add_lot_valid(user_id, item_id, count, price, store)

  error = ""
  inventory = false
  lots = false
  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id)
      error << "<error>User id contains invalid characters.</error>"
    else
      if Lot.where(:user_id => user_id.to_i).count > 5
        error << "You have the maximum number of lots."
        lots = true
      else
        if item_id != ""
          if !(/^[0-9\-_]+$/ =~ user_id)
            error << "<error>Item id contains invalid characters.</error>"
          elsif store[item_id.to_i] == nil
            error << "<error>Item with such id does not exist.</error>"
          else
            if count != ""
              if !(/^[0-9\-_]+$/ =~ user_id)
                error << "<error>Count contains invalid characters.</error>"
              elsif Item[:user_id => user_id.to_i, :item_id => item_id.to_i].count_item < count.to_i
                error << "<error>Count is more than possible.</error>"
                inventory = true
              end
            else
              error << "<error>Enter the count.</error>"
            end
            if price != ""
              if !(/^[0-9\-_]+$/ =~ user_id)
                error << "<error>Price contains invalid characters.</error>"
              elsif price.to_i < store[item_id.to_i].price.to_i
                error << "<error>Price should be more than the base price of the item.</error>"
              elsif price.to_i > store[item_id.to_i].price.to_i * 10
                error << "<error>Price should not be 10 times the base price of the item.</error>"
                inventory = true
              end
            else
              error << "<error>Enter the price.</error>"
            end
          end
        else
          error << "<error>Enter the item id.</error>"
        end
      end
    end
  else
    if item_id == ""
      error << "<error>Enter the item id.</error>"
    end
    if count == ""
      error << "<error>Enter the count.</error>"
    end
    if price == ""
      error << "<error>Enter the price.</error>"
    end
    error << "<error>Enter the user id.</error>"
  end

  if error != ""
    error << "<data><user_id>#{user_id}</user_id><item_id>#{item_id}</item_id><count>#{count}</count><price>#{price}</price></data>"
    if inventory
      show_inventory(store, user_id.to_i, "add_lot", "<errors>#{error}</errors>")
    elsif lots
      show_lots(store, user_id.to_i, "add_lot", "<errors>#{error}</errors>")
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"add_lot\"><errors>#{error}</errors></information>"
    end
  else
    lot = add_lot(user_id.to_i, item_id.to_i, count.to_i, price.to_i)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"add_lot\"><data><lot id=\"#{lot.id}\" name=\"#{store[Item[:item_id => lot.item_id].item_id].name}\" count=\"#{lot.count_lot}\" price=\"#{lot.price}\"/></data><message>Lot was successfully added!</message></information>"
  end

end
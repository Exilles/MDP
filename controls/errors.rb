def registration_valid(login, password)

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
    User.insert(:login => login, :password => password, :money => 100)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"registration\"><data><login>#{login}</login><password>#{password}</password></data><message>Account successfully registered!</message></information>"
  end

end

def inventory_valid(user_id, store)

  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id) || user_id.include?("-") || user_id.include?("_")
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
    if !(/^[0-9\-_]+$/ =~ user_id) || user_id.include?("-") || user_id.include?("_")
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
  flag_inventory = false
  flag_lots = false
  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id) || user_id.include?("-") || user_id.include?("_")
      error << "<error>User id contains invalid characters.</error>"
      if item_id != ""
        if !(/^[0-9\-_]+$/ =~ item_id) || item_id.include?("-") || item_id.include?("_")
          error << "<error>Item id contains invalid characters.</error>"
        end
      else
        error << "<error>Enter the item id.</error>"
      end
      if count != ""
        if !(/^[0-9\-_]+$/ =~ count)
          error << "<error>Count contains invalid characters.</error>"
        end
      else
        error << "<error>Enter the count.</error>"
      end
      if price != ""
        if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
          error << "<error>Price contains invalid characters.</error>"
        end
      else
        error << "<error>Enter the price.</error>"
      end
    else
      if Lot.where(:user_id => user_id.to_i).count > 6
        error << "You can have a maximum of 5 lots."
        flag_lots = true
      else
        if item_id != ""
          if !(/^[0-9\-_]+$/ =~ item_id) || item_id.include?("-") || item_id.include?("_")
            error << "<error>Item id contains invalid characters.</error>"
            if count != ""
              if !(/^[0-9\-_]+$/ =~ count)
                error << "<error>Count contains invalid characters.</error>"
              end
            else
              error << "<error>Enter the count.</error>"
            end
            if price != ""
              if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
                error << "<error>Price contains invalid characters.</error>"
              end
            else
              error << "<error>Enter the price.</error>"
            end
          elsif store[item_id.to_i] == nil
            error << "<error>Item with such id does not exist.</error>"
          else
            if count != ""
              if !(/^[0-9\-_]+$/ =~ count)
                error << "<error>Count contains invalid characters.</error>"
                if price != ""
                  if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
                    error << "<error>Price contains invalid characters.</error>"
                  end
                else
                  error << "<error>Enter the price.</error>"
                end
              elsif Item[:user_id => user_id.to_i, :item_id => item_id.to_i].count_item < count.to_i
                error << "<error>Count is more than possible.</error>"
                flag_inventory = true
              end
            else
              if price != ""
                if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
                  error << "<error>Price contains invalid characters.</error>"
                end
              else
                error << "<error>Enter the price.</error>"
              end
              error << "<error>Enter the count.</error>"
            end
            if price != ""
              if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
                error << "<error>Price contains invalid characters.</error>"
              elsif price.to_i < store[item_id.to_i].price.to_i
                error << "<error>Price should be more than the base price of the item.</error>"
                flag_inventory = true
              elsif price.to_i > store[item_id.to_i].price.to_i * 10
                error << "<error>Price should not be 10 times the base price of the item.</error>"
                flag_inventory = true
              end
            else
              error << "<error>Enter the price.</error>"
            end
          end
        else
          if count != ""
            if !(/^[0-9\-_]+$/ =~ count)
              error << "<error>Count contains invalid characters.</error>"
            end
          else
            error << "<error>Enter the count.</error>"
          end
          if price != ""
            if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
              error << "<error>Price contains invalid characters.</error>"
            end
          else
            error << "<error>Enter the price.</error>"
          end
          error << "<error>Enter the item id.</error>"
        end
      end
    end
  else
    if item_id != ""
      if !(/^[0-9\-_]+$/ =~ item_id) || item_id.include?("-") || item_id.include?("_")
        error << "<error>Item id contains invalid characters.</error>"
      end
    else
      error << "<error>Enter the item id.</error>"
    end
    if count != ""
      if !(/^[0-9\-_]+$/ =~ count)
        error << "<error>Count contains invalid characters.</error>"
      end
    else
      error << "<error>Enter the count.</error>"
    end
    if price != ""
      if !(/^[0-9\-_]+$/ =~ price) || price.include?("-") || price.include?("_")
        error << "<error>Price contains invalid characters.</error>"
      end
    else
      error << "<error>Enter the price.</error>"
    end
    error << "<error>Enter the user id.</error>"
  end

  if error != ""
    error = "<data><user_id>#{user_id}</user_id><item_id>#{item_id}</item_id><count>#{count}</count><price>#{price}</price></data><errors>#{error}</errors>"
    if flag_inventory
      show_inventory(store, user_id.to_i, "add_lot", error)
    elsif flag_lots
      show_lots(store, user_id.to_i, "add_lot", error)
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"add_lot\">#{error}</information>"
    end
  else
    error << "<data><user_id>#{user_id}</user_id><item_id>#{item_id}</item_id><count>#{count}</count><price>#{price}</price></data><message>Lot was successfully added!</message>"
    show_lots(store, user_id.to_i, "add_lot", error)
  end

end

def return_valid(user_id, lot_id, store)

  error = ""
  flag = false
  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id) || user_id.include?("-") || user_id.include?("_")
      error << "<error>User id contains invalid characters.</error>"
      if lot_id != ""
        if !(/^[0-9\-_]+$/ =~ lot_id) || lot_id.include?("-") || lot_id.include?("_")
          error << "<error>Lot id contains invalid characters.</error>"
        end
      else
        error << "<error>Enter the lot id.</error>"
      end
    elsif !User.where(:id => user_id.to_i).any?
      error << "<error>User does not exist.</error>"
      else
        if lot_id != ""
          if !(/^[0-9\-_]+$/ =~ lot_id) || lot_id.include?("-") || lot_id.include?("_")
            error << "<error>Lot id contains invalid characters.</error>"
          elsif !Lot.where(:id => lot_id.to_i).any?
            error << "<error>Lot does not exist.</error>"
            flag = true
          elsif Lot[:id => lot_id.to_i].user_id != user_id.to_i
            error << "<error>This user does not have such a lot.</error>"
            flag = true
          end
        else
          error << "<error>Enter the lot id.</error>"
        end
    end
  else
    if lot_id != ""
      if !(/^[0-9\-_]+$/ =~ lot_id) || lot_id.include?("-") || lot_id.include?("_")
        error << "<error>Lot id contains invalid characters.</error>"
      end
    else
      error << "<error>Enter the lot id.</error>"
    end
    error << "<error>Enter the user id.</error>"
  end

  if error != ""
    error = "<data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id></data><errors>#{error}</errors>"
    if flag
      show_lots(store, user_id.to_i, "return_lot", error)
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"return_lot\">#{error}</information>"
    end
  else
    return_lot(lot_id.to_i)
    error << "<data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id></data><message>Lot was successfully returned!</message>"
    show_inventory(store, user_id.to_i, "return_lot", error)
  end

end

def add_ad_valid(user_id, lot_id, store)

  error = ""
  flag = false
  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id) || user_id.include?("-") || user_id.include?("_")
      error << "<error>User id contains invalid characters.</error>"
      if lot_id != ""
        if !(/^[0-9\-_]+$/ =~ lot_id) || lot_id.include?("-") || lot_id.include?("_")
          error << "<error>Lot id contains invalid characters.</error>"
        end
      else
        error << "<error>Enter the lot id.</error>"
      end
    elsif !User.where(:id => user_id.to_i).any?
      error << "<error>User does not exist.</error>"
    else
      if lot_id != ""
        if !(/^[0-9\-_]+$/ =~ lot_id) || lot_id.include?("-") || lot_id.include?("_")
          error << "<error>Lot id contains invalid characters.</error>"
        elsif !Lot.where(:id => lot_id.to_i).any?
          error << "<error>Lot does not exist.</error>"
          flag = true
        elsif Lot[lot_id.to_i].user_id != user_id.to_i
          error << "<error>This user does not have such a lot.</error>"
          flag = true
        elsif Lot[lot_id.to_i].ad_id != nil
          error << "<error>Lot already has an ad.</error>"
          flag = true
        elsif User[user_id.to_i].money < 10
          error << "<error>There is not enough money to place an ad. Ad cost 10 coins.</error><coins>#{User[user_id.to_i].money}</coins>"
        end
      else
        error << "<error>Enter the lot id.</error>"
      end
    end
  else
    if lot_id != ""
      if !(/^[0-9\-_]+$/ =~ lot_id) || lot_id.include?("-") || lot_id.include?("_")
        error << "<error>Lot id contains invalid characters.</error>"
      end
    else
      error << "<error>Enter the lot id.</error>"
    end
    error << "<error>Enter the user id.</error>"
  end

  if error != ""
    error = "<data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id></data><errors>#{error}</errors>"
    if flag
      show_lots(store, user_id.to_i, "add_lot", error)
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"add_lot\">#{error}</information>"
    end
  else
    add_ad(store, user_id.to_i, lot_id.to_i)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"add_ad\"><data><user_id>#{user_id}</user_id><lot_id>#{lot_id}</lot_id></data><message>Ad was successfully added!</message></information>"
  end

end

def delete_ad_valid(user_id, ad_id, store)

  error = ""
  flag = false
  if user_id != ""
    if !(/^[0-9\-_]+$/ =~ user_id) || user_id.include?("-") || user_id.include?("_")
      error << "<error>User id contains invalid characters.</error>"
      if ad_id != ""
        if !(/^[0-9\-_]+$/ =~ ad_id) || ad_id.include?("-") || ad_id.include?("_")
          error << "<error>Ad id contains invalid characters.</error>"
        end
      else
        error << "<error>Enter the ad id.</error>"
      end
    elsif !User.where(:id => user_id.to_i).any?
      error << "<error>User does not exist.</error>"
    else
      if ad_id != ""
        if !(/^[0-9\-_]+$/ =~ ad_id) || ad_id.include?("-") || ad_id.include?("_")
          error << "<error>Ad id contains invalid characters.</error>"
        elsif !Ad.where(:id => ad_id.to_i).any?
          error << "<error>Ad does not exist.</error>"
          flag = true
        elsif Lot[:ad_id => ad_id.to_i].user_id != user_id.to_i
          error << "<error>This user does not have such an ad.</error>"
          flag = true
        end
      else
        error << "<error>Enter the ad id.</error>"
      end
    end
  else
    if ad_id != ""
      if !(/^[0-9\-_]+$/ =~ ad_id) || ad_id.include?("-") || ad_id.include?("_")
        error << "<error>Ad id contains invalid characters.</error>"
      end
    else
      error << "<error>Enter the ad id.</error>"
    end
    error << "<error>Enter the user id.</error>"
  end

  if error != ""
    error = "<data><user_id>#{user_id}</user_id><ad_id>#{ad_id}</ad_id></data><errors>#{error}</errors>"
    if flag
      show_lots(store, user_id.to_i, "delete_lot", error)
    else
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"delete_lot\">#{error}</information>"
    end
  else
    delete_ad(user_id.to_i, ad_id.to_i)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"delete_ad\"><data><user_id>#{user_id}</user_id><ad_id>#{ad_id}</ad_id></data><message>Ad was successfully deleted!</message></information>"
  end

end

def filter_ads_valid(name, count, price)

  error = ""
  if name.to_s == "" && count.to_s == "" && price.to_s == ""
    error << "<error>Enter the parameters.</error>"
  else
    error << "<error>Name contains invalid characters.</error>" if (!(/^[a-zA-Z\-_]+$/ =~ name.to_s) || name.to_s.include?("-") || name.to_s.include?("_")) && name.to_s != ""
    error << "<error>Count contains invalid characters.</error>" if (!(/^[0-9\-_]+$/ =~ count.to_s) || count.to_s.include?("-") || count.to_s.include?("_")) && count.to_s != ""
    error << "<error>Price contains invalid characters.</error>" if (!(/^[0-9\-_]+$/ =~ price.to_s) || price.to_s.include?("-") || price.to_s.include?("_")) && price.to_s != ""
  end

  if error != ""
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><information type=\"ads\"><data><name>#{name}</name><count>#{count}</count><price>#{price}</price></data><errors>#{error}</errors></information>"
  else
    filter_ads(name, count, price)
  end

end
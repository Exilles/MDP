class User

  def authorization(login, password)

    if User.where(:login => login, :password => password).any?
      return User[:login => login, :password => password].id
    else
      return false
    end

  end

  def get_user_inventory(id)

   if id != ''

    if (/^[0-9\-_]+$/ =~ id)

      if User.where(:id => id).any?

        all_items = Item.new('item.yml').all

        #вариант через String
        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<inventory money=\"#{User[:id=>id].money}\" nickname=\"#{User[:id=>id].login}\" user_id=\"#{id}\" >  \n"
        Item.where(:user_id => id).each do |item|
          xml << "  <item name=\"#{all_items[item.item_id].name}\" count=\"#{item.count_item}\" cost=\"#{all_items[item.item_id - 1].cost}\" item_id=\"#{item.id}\"/>\n"
        end
        xml << "</inventory>"

        #рабочий вариант через Nokogiri
        # Nokogiri::XML::Builder.new {|xml|
        #   xml.items "Inventory" do
        #   Item.where(:user_id => id).each do |useritem|
        #     #item = all_items[useritem.item_id - 1]
        #     xml.item :cost => all_items[useritem.item_id - 1].cost , :name => all_items[useritem.item_id - 1].name, :count => useritem.count_item
        #    end
        #   end
        #    }.to_xml
      else
         enter_data_error(id,'inventory','user_id','User does not exist')
      end
     else
       enter_data_error(id,'inventory','user_id','User_id contains invalid characters')
    end
   else
     enter_data_error(id,'inventory','user_id','User_id does not enter')
  end


  end

end


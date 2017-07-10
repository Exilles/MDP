class User

  def authorization(login, password)

    if User.where(:login => login, :password => password).any?
      return User[:login => login, :password => password].id
    else
      return false
    end

  end

  def get_user_inventory(id)

    all_items = Item.new('item.yml').all

    #вариант через String
    xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n" + "<inventory Баланс: \"#{User[:id=>id].money}\" Nickname: \"#{User[:id=>id].login}\" >  \n"
    Item.where(:user_id => id).each do |item|
      xml << "  <Название предмета: \"#{all_items[item.item_id ].name}\" Количество: \"#{item.count_item}\" Минимальная цена: \"#{all_items[item.item_id - 1].cost}\" id предмета: \"#{item.id}\">\n"
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

  end

end

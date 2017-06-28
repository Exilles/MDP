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

    Nokogiri::XML::Builder.new {|xml|
      xml.items "Inventory" do
      Item.where(:user_id => id).each do |useritem|
        item = all_items[useritem.item_id - 1]
         xml.item :cost => item['cost'], :name => item['name'], :count => useritem.count_item
       end
      end
       }.to_xml

    # File.open("Inventory.xml", "w:UTF-8") { |f| f.write(xml); f.close}
    #
    # file = File.new("Inventory.xml", "r:UTF-8")
    # doc = REXML::Document.new(file)
    # file.close
    #
    # Item.where(:user_id => id).each do |useritem|
    #
    #  items = doc.elements.find('items').first
    #
    #  item = all_items[useritem.item_id - 1]
    #
    #  items.add_element 'item', {'cost' => item['cost'], 'name' => item['name'], 'count' => useritem.count_item}
    #
    # end
    #
    # file = File.new("Inventory.xml", "w:UTF-8")
    # doc.write(file,2)
    # file.close

  end

end

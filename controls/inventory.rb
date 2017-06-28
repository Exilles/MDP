def show(store, id)

  Nokogiri::XML::Builder.new {|xml|
    xml.inventory do
      Item.where(:user_id => id).each do |item|
        xml.item :name => store[item.item_id - 1].name, :count => item.count_item, :cost => store[item.item_id - 1].cost
      end
    end
  }.to_xml

end





class Lot


  # def new_ad
  #  puts 'hello'
  # end
  #
  # def show_ad
  #
  # end
  #
  # def create_ad
  #
  # end
  #
  # def destroy_ad
  #
  # end
  #
  # def edit_ad
  #
  # end

  def get_user_lots(id)

     all_items = Item.new('item.yml').all

     xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n" + "<lots>\n"
     Lot.where(:user_id => id).each do |lot|
      xml << "  <lot name=\"#{all_items[Item[:id => lot.item_id].item_id - 1].name}\" price=\"#{lot.price}\" count=\"#{lot.count_lot}\" item_id=\"#{lot.item_id}\" lot_id=\"#{lot.id}\" >\n"
     end
     xml << "</lots>"


      #вариант через Nokogiri
      # Nokogiri::XML::Builder.new {|xml|
      #   xml.lots "Lots" do
      #     Lot.where(:user_id => 1).each do |userlot|
      #       xml.lot :price => userlot.price, :count => userlot.count_lot
      #     end
      #   end
      # }.to_xml

  end

  def create_new_lot(user_id, item_id, price, count_lot)


    if Item[:id => item_id, :user_id=> user_id].count_item.to_i - count_lot.to_i >= 0
     Lot.insert(:price => price, :count_lot => count_lot, :user_id=>user_id , :item_id => item_id)
     Item.where(:id => item_id, :user_id=> user_id).update(:count_item => Item[:id => item_id, :user_id=> user_id].count_item.to_i - count_lot.to_i)
    end
  end

end

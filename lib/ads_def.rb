

class Ad

  def show_ads

    xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
    Ad.each do |ad|
      xml << "  <Nickname продавца: \"#{User[:id => Lot[:id => ad.lot_id].user_id].login}\" Товар: \"#{ad.name}\" Описание: \"#{ad.description}\">\n"
    end
    xml << "</ads>"

  end

  def add_ad(user_id, lot_id)
    store  = Item.new('item.yml').all
    lot = Lot[:id => lot_id]
    if !lot.ad_id
      ad = Ad.create(:name => store[Item[:id => lot.item_id].item_id - 1].name, :description => " #{lot.count_lot} шт. по цене #{lot.price} за штуку", :lot_id => lot_id)
      Lot.where(:id => lot_id).update(:ad_id => ad.id)
      User.where(:id => user_id).update(:money => User[:id => user_id].money - 5)
      true
    else
      false
    end

  end

  def delete_add(user_id,id)

    Lot.where(:ad_id => id, :user_id => user_id).update(:ad_id => nil)
    Ad.where(:id => id).delete

  end


  def filter(name_lot, price_lot, count_lot)
    filter = DB[:lots].join_table(:inner, DB[:ads], :id => :ad_id)
    filter.where(:name => name_lot, :price => price_lot, :count_lot => count_lot)

    xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
    filter.each do |ads|
      xml << "  <nickname=\"#{User[:id => ads.fetch(:user_id)].login}\" name = \"#{ads.fetch(:name)}\" description=\"#{ads.fetch(:description)}\">\n"
    end
    xml << "</ads>"
 end

end
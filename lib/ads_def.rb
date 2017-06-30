

class Ad
  def show_ads

    xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
    Ad.each do |ad|
      xml << "  <nickname=\"#{User[:id => Lot[:id => ad.lot_id].user_id].login}\" title = \"#{ad.name}\" description=\"#{ad.description}\">\n"
    end
    xml << "</ads>"

  end

  def add_ad(user_id, lot_id, description, name)

    if !Lot[:id => lot_id].ad_id
      ad = Ad.create(:name => name, :description => description, :lot_id => lot_id)
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



end
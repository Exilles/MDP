def show_ads

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
  Ad.each do |ad|
    xml << "  <name=\"#{ad.name}\" description=\"#{ad.description}\">\n"
  end
  xml << "</ads>"

end

def add_ad(user_id, lot_id, description)

  if !Lot.where[:id => lot_id].ad_id
    ad = Ad.create(:name => User[:id => user_id].login, :description => description, :lot_id => lot_id)
    Lot.where(:id => lot_id).update(:ad_id => ad.id)
    true
  else
    false
  end

end

def delete_add(id)

  Lot.where(:ad_id => id).update(:ad_id => nil)
  Ad.where(:id => id).delete

end
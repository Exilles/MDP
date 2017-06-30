def show_ads

  xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
  Ad.each do |ad|
    xml << "  <user_id=\"#{ad.name}\" description=\"#{ad.description}\">\n"
  end
  xml << "</ads>"

end

def add_ad(user_id, lot_id, description)

  user = User[:id => user_id]
  lot = Lot[:id => lot_id, :user_id => user_id]
  if !lot.ad_id && user.money >= 5
    ad = Ad.create(:name => user.id, :description => description, :lot_id => lot_id)
    lot.update(:ad_id => ad.id)
    user.update(:money => user.money - 5)
  end

end

def delete_add(id)

  Lot[:ad_id => id].update(:ad_id => nil)
  Ad[:id => id].delete

end
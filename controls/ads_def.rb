

class Ad

  def show_ads

    xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
    Ad.each do |ad|
      xml << "  <Nickname_seller=\"#{User[:id => Lot[:id => ad.lot_id].user_id].login}\" user_id=\"#{Lot[:id => ad.lot_id].user_id}\" item_name=\"#{ad.name}\" description=\"#{ad.description}\"/>\n"
    end
    xml << "</ads>"

  end

  def add_ad(user_id, lot_id)
    store  = Item.new('item.yml').all
    lot = Lot[:id => lot_id]
    if !lot.ad_id #проверям не выставлено ли уже объявление на этот лот
      ad = Ad.create(:name => store[Item[:id => lot.item_id].item_id].name, :description => " #{lot.count_lot} шт. по цене #{lot.price} за штуку", :lot_id => lot_id)
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


  def filter(name_lot = nil, price_lot = nil, count_lot = nil)

    filter = DB[:lots].join_table(:inner, DB[:ads], :id => :ad_id)

    if name_lot!= nil
     filter =  filter.where(:name => name_lot) #фильтр по названию объявления
    end

      if price_lot!=nil
       filter = filter.where(:price => price_lot) #фильтр по цене
      end

        if count_lot!=nil
          filter = filter.where(:count_lot => count_lot) #фильтр по количеству предметов в лоте
        end

    xml = "?xml version=\"1.0\" encoding=\"UTF-8\"?\n<ads>\n"
    filter.each do |ads| #ads - hesh
      xml << "  <seller_nickname=\"#{User[:id => ads.fetch(:user_id)].login}\" seller_id=\"#{ads.fetch(:user_id)}\" item_name=\"#{ads.fetch(:name)}\" description=\"#{ads.fetch(:description)}\"/>\n"
    end
    xml << "</ads>"
 end

end
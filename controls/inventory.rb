def show(id)

  Item.where(:user_id => id)

end
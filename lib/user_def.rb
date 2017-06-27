class User

  def authorization(login, password)

    if User.where(:login => login, :password => password).any?
      return User[:login => login, :password => password].id
    else
      return false
    end

  end

  def get_user_inventory(id)
    Item.where(:user_id => id)

  end

end

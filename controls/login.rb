def login(login, password)

  user = User[:login => login, :password => password]
    if  user
      user.id
    else
      false
    end

end

def registration(login, password)

  User.insert(:login => login, :password => password, :money => 100)

end
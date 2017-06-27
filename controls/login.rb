def login(login, password)

    if  User.where(:login => login, :password => password).any?
      User[:login => login, :password => password].id
    else
      false
    end

end

def registration(login, password)

  User.insert(:login => login, :password => password, :money => 100)

end
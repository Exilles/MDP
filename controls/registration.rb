def registration(login, password)

  User.insert(:login => login, :password => password, :money => 100)

end
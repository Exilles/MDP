def register_valid(login, password)

  error = ""
  error << "Error: Login is too long. A maximum of 15 characters.\n" if (login.length > 16)
  if login.length == 0
    error << "Error: Enter your login.\n"
  elsif login.length < 4
    error << "Error: Login is too short. A minimum of 4 characters.\n"
  end
  if login.length > 0
    error << "Error: Login contains invalid characters.\n" if !(/^[a-zA-z\-_]+$/=~login) || login.include?("-") || login.include?("_")
  end
  error << "Error: This login already exists.\n" if User.where(:login => login).any?
  error << "Error: Password is too long. A maximum of 15 characters.\n" if (password.length > 16)
  if password.length == 0
    error << "Error: Enter your password.\n"
  elsif password.length < 4
    error << "Error: Password is too short. A minimum of 4 characters.\n"
  end
  error << "Error: Password can't contain a space character.\n" if password.include?(" ")
  error

end

def login_valid(login, password)

  error = ""
  if login.length > 0
    if !User.where(:login => login).any?
      error << "Error: A user with such a login does not exist.\n"
    end
    if password.length > 0
      if !User.where(:login => login, :password => password).any?
        error << "Error: Incorrect password.\n"
      end
    else
      error << "Error: Enter your password.\n"
    end
  elsif password.length > 0
    error << "Error: Enter your login.\n"
  else
    error << "Error: Enter your login.\n"
    error << "Error: Enter your password.\n"
  end
  error

end


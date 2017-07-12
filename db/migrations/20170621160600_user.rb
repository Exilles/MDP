Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :login
      String :password
      Integer :money
    end
  end
end
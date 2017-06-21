Sequel.migration do
  change do
    create_table :users do
    primary_key :id
    String :Login
    String :Password
    Integer :Money
  end
  end
end
Sequel.migration do
  change do
    create_table :items do
      primary_key :id
      String :name
      Integer :countItem
      foreign_key :user_id
    end
  end
end
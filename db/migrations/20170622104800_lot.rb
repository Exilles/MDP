Sequel.migration do
  change do
    create_table :lots do
      primary_key :id
      Integer :countLot
      Integer :price
      foreign_key :user_id
      foreign_key :ad_id
    end
  end
end
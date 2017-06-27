Sequel.migration do
  change do
    create_table :items do
      primary_key :id
      Integer :item_id
      Integer :count_item
      foreign_key :user_id
    end
  end
end
Sequel.migration do
  change do
    create_table :lots do
      primary_key :id
      Integer :count_lot
      Integer :price
      Integer :user_id
      Integer :item_id
      Integer :ad_id
      column :time, 'real[]', :default => '{}'
    end
  end
end

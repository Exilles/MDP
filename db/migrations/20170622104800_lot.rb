Sequel.migration do
  change do
    create_table :lots do
      primary_key :id
      Integer :count_lot
      Integer :price
      column :update_time, 'bigint[]', :default=>'{}' #столбец для времени обновления данных
      foreign_key :user_id
      foreign_key :ad_id
      foreign_key :item_id
    end
  end
end
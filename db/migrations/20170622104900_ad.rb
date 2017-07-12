Sequel.migration do
  change do
    create_table :ads do
      primary_key :id
      Integer :user_id
      String :description
      Integer :lot_id
    end
  end
end
Sequel.migration do
  change do
    create_table :ads do
      primary_key :id
      String :name
      String :description
      Integer :lot_id
    end
  end
end
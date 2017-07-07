Sequel.migration do
  change do
    create_table :finoperations do
      primary_key :id
      Integer :user_buyer_id
      Integer :lot_id
      Fixnum :operation_time
    end
  end
end
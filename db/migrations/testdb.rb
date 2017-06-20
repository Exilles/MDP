
Sequel.migration do
 change do
   create_table (:Users) do
     primary_key :id
     String :Login
     String :Password
     Integer :Money
   end

   create_table (:Items) do
     primary_key :id
     Integer :CountItems
     String :Name
     belongs_to :User
   end

   create_table (:Lots) do
     primary_key :id
     Integer :CountLot
     Integer :Cost
     belongs_to :User
     belongs_to :Ad
   end

   create_table (:Ads) do
     primary_key :id
     String :Name
     String :Description
   end
 end

end



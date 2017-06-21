require 'sequel'
require 'pg'
DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market_db', :user=>'admin', :password=>'111')
Sequel.extension :migration, :core_extensions do
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

Test = DB[:Users]
Test.insert(:Login => 'admin', :Password => '111', :Money => 1000)
puts "#{Test.count}"

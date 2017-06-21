require 'sequel'
require 'pg'

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market', :user=>'admin', :password=>'111')

DB.create_table (:Users) do
  primary_key :id
  String :Login
  String :Password
  Integer :Money
end

DB.create_table (:Items) do
  primary_key :id
  Integer :CountItems
  String :Name
  foreign_key :Users_id, :Users
end

DB.create_table (:Ads) do
  primary_key :id
  String :Name
  String :Description
end

DB.create_table (:Lots) do
  primary_key :id
  Integer :CountLot
  Integer :Cost
  foreign_key :Users_id, :Users
  foreign_key :Ads_id, :Ads
end



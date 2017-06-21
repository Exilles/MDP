require 'sequel'
require 'pg'

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market', :user=>'admin', :password=>'111')

DB.create_table (:users) do
  primary_key :id
  String :login
  String :password
  Integer :money
  one_to_many :items
  one_to_many :lots
end

DB.create_table (:items) do
  primary_key :id
  Integer :countItems
  String :name
  Integer :cost
  foreign_key :users_id, :users
  many_to_one :users
end

DB.create_table (:ads) do
  primary_key :id
  String :name
  String :description
end

DB.create_table (:lots) do
  primary_key :id
  Integer :countLot
  Integer :cost
  foreign_key :users_id, :users
  foreign_key :ads_id, :ads
  many_to_one :users
end

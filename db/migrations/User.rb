require 'sequel'
require 'pg'
Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market_db', :user=>'admin', :password=>'111')

class User < Sequel::Model
end

Sequel.migration do
  change do
    create_table(:Users) do
      primary_key :id
      String :Login
      String :Password
      Integer :Money
    end
  end
end



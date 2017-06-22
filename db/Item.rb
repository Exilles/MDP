require 'sequel'
require 'pg'

class Item < Sequel::Model (:items);
  many_to_one :users
end
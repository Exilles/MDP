require 'sequel'
require 'pg'

class Lot < Sequel::Model (:lots);
  many_to_one :users
  one_to_one :ads
end
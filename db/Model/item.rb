class Item < Sequel::Model(DB[:items])
  attr_accessor :name, :cost
  many_to_one :user
  one_to_one :lot
end
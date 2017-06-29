class Lot < Sequel::Model(DB[:lots])
  many_to_one :user
  one_to_one :ad
  one_to_one :item
end
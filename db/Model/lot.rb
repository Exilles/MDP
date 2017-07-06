class Lot < Sequel::Model(DB[:lots])
  # plugin :serialization
  # serialize_attributes :pg_array, :update_time
  many_to_one :user
  one_to_one :ad
  one_to_one :item
end
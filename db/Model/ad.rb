class Ad < Sequel::Model(DB[:ads])
  one_to_one :lot
end
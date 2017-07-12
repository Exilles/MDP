class Item < Sequel::Model (DB[:items]);

  many_to_one :user
  one_to_one :lot

end

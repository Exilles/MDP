class User < Sequel::Model (DB[:users]);
  one_to_many :items
  one_to_many :lots
end

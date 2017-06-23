class User < Sequel::Model (:users);
  # one_to_many :items
  one_to_many :lots
end

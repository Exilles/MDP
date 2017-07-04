require 'yaml/store'

class Item

  def initialize(file_name)
    @store = YAML::Store.new(file_name)
  end

  def all
    @store.transaction do
      @store.roots.map { |id| @store[id]}
    end
  end

end
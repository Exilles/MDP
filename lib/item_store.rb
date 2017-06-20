require 'yaml/store'

class ItemStore

  def initialize(file_name)
    @store = YAML::Store.new(file_name)
  end

  def find(id)
    @store.transaction do
      @store[id]
    end
  end

  def all
    @store.transaction do
      @store.roots.map { |id| @store[id]}
    end
  end

  def save (item)
    @store.transaction do
      unless item.id
        highest_id = @store.roots.max || 0
        item.id = highest_id + 1
      end
      @store[item.id] = item
    end
  end

end
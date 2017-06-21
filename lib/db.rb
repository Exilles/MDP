require 'sequel'
require 'pg'

class Db
  def initialize
    @DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market', :user=>'admin', :password=>'111')
  end

  def insert (table, arg ={})
    # DB[:users].insert(:login => params['login'].to_s, :password => params['password'].to_s, :money => 100)
    DB[:users].insert(:login => params['login'].to_s, :password => params['password'].to_s, :money => 100)
  end
end



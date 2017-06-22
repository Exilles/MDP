require 'sequel'
require 'pg'
require 'user'
require 'item'
require 'ad'
require 'lot'

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'market', :user=>'admin', :password=>'111')


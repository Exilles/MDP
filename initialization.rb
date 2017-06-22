require 'sequel'
require 'pg'
require 'yaml'
require 'erb'

DB=Sequel.connect(YAML.load(ERB.new(File.read('db/config/database.yml')).result)['production'])

require_relative 'db/Model/ad'
require_relative 'db/Model/lot'
require_relative 'db/Model/item'
require_relative 'db/Model/user'

test=DB[:users]

muser=test.where(:id => 1)

item=DB[:items]

itemt = item.where(:Name => 'phone')
itemt.user = User[:login => 'Misha']







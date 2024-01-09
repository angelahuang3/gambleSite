require 'sinatra'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/players.database")

# Create model
class User
    include DataMapper::Resource
    property :username, String, key: true, unique_index: true # primary key
    property :password, String, required: true
    property :totalWin, Integer, required: true
    property :totalLoss, Integer, required:true
    property :totalProfit, Integer, required:true
end
DataMapper.finalize
DataMapper.auto_upgrade!
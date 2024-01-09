require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

enable (:sessions)

# Configure Database
configure :development do
    DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/player.db")
  end
  
  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

require "./players"
require "./bet"

get '/' do
    if session[:login]
        @title = "Gamble"
        erb :bet
    else
        @title = "Login or Signup"
        erb :main
    end
end

# Sign up
get '/signup' do
    @title = "Sign Up"
    erb :signup
end

post '/signup' do
    username = params[:username]
    password = params[:password]
    existing_user = User.get(username)

    if existing_user
        session[:signerr] = "Username has already been taken."
        redirect :signup
    else
        user = User.new(username: username, password: password, totalWin: 0, totalLoss: 0, totalProfit: 0)
        user.save
        session[:login] = true
        session[:username] = username
        session[:password] = password
        session[:totalWin] = 0
        session[:totalLoss] = 0
        session[:totalProfit] = 0
        session[:sessionWin] = 0
        session[:sessionLoss] = 0
        session[:sessionProfit] = 0
        session[:message] ="Signup successful! Please log in."
        redirect :login
    end
end


# Login
get '/login' do
    @title = "Login"
    session[:login] = nil
    erb :login
  end

post '/login' do  
    username = params[:username]
    password = params[:password]
    user = User.get(username)

    if user.nil? || user.password != password
        @title = "Login"
        session[:login] = false
        erb :login
    else
        @title = "Gamble"
        session[:login] = true
        session[:username] = username
        session[:password] = password
        session[:totalWin] = user.totalWin
        session[:totalLoss] = user.totalLoss
        session[:totalProfit] = user.totalProfit
        session[:sessionWin]=0
        session[:sessionLoss]=0
        session[:sessionProfit]=0
        session[:user] = user
        redirect to("/")
    end
end

get '/logout' do
    @user=User.get(session[:username])
    @user.update(totalWin: session[:totalWin], totalLoss: session[:totalLoss], totalProfit: session[:totalProfit])
    session.clear
    redirect to('/')
end


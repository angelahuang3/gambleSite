
get '/bet' do
    halt(401, 'Not Authorized') unless session[:login]==true  #does not allow access unless logged in
    @title = "Gamble"
    erb :bet
end

post '/bet' do
    begin
        @title = "Gamble"
        @user = User.get(session[:username])
        roll = rand(1...6)
        bet = Integer(params[:money])
        guess = Integer(params[:guess])
        
        if bet < 1 || guess < 1 || guess > 6
            session[:error] =  true
        end

        if roll == guess
            session[:error] =  false
            session[:totalWin] += bet
            session[:sessionWin] += bet
            session[:totalProfit] = session[:totalWin]-session[:totalLoss]
            session[:sessionProfit] = session[:sessionWin]-session[:sessionLoss]
            session[:win] = true 
        else
            session[:error] =  false
            session[:totalLoss] += bet
            session[:sessionLoss] += bet
            session[:totalProfit] = session[:totalWin]-session[:totalLoss]
            session[:sessionProfit] = session[:sessionWin]-session[:sessionLoss]
            session[:win] = false   
        end
        session[:login] = true
        redirect to('/')
    rescue=> e
        logger.error("Error in /bet: #{e.message}")
        e.backtrace.each { |line| logger.error(line) }
        session[:error] = true
        redirect to('/')
    end
end
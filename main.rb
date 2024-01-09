require 'sinatra'
require 'sinatra/reloader'

enable :sessions

get '/new' do
    erb(:home)
end

post '/submit' do
    input = params[:script_input]
    if(input.start_with?("<script>") && input.end_with?("</script>"))
        session[:message] = input
    else 
        session[:alert] = "Please enter a valid script string"
    end
    # session[:message] = input
    redirect('/test')
end

get '/test' do
    erb(:test)
end
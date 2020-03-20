# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"
require "geocoder"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

maps_key = ENV['GOOGLE_MAPS_KEY']
concerts_table = DB.from(:concerts)
reviews_table = DB.from(:reviews)
users_table = DB.from(:users)
# key AIzaSyAOaIED8aeDTnQjBi41Xp6gofwgk-UV4fs

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do # this is the index route
    puts "params: #{params}" #for debugging; only prints to console
    
    pp concerts_table.all.to_a #get all data from concert table (copied from sequel cheatsheet)
     # list the concert using loop
    @concerts = concerts_table.all.to_a # first, store events in a var; next add loop to events.erb
    
    view "concerts"
end

get "/concerts/:id" do # show route (DONE)
    puts "params: #{params}"
        
    pp concerts_table.where(id: params["id"]).to_a[0] # copied from sequel cheatsheet, changed 1 to params[] to make it dynamic
    @concert = concerts_table.where(id: params["id"]).to_a[0]
    @reviews = reviews_table.where(concert_id: @concert[:id]).to_a
    @users_table = users_table    

    view "concert"
end

# add the form route to create new associated thing (DONE)
get "/concerts/:id/reviews/new" do
    puts "params: #{params}"

    @concert = concerts_table.where(id: params["id"]).to_a[0]
    view "new_review"
end

# submit form to this route to create new row in reviews db (DONE)
post "/concerts/:id/reviews/create" do
    puts "params: #{params}"

    # grab the concert
    @concert = concerts_table.where(id: params[:id]).to_a[0]

    reviews_table.insert(
        concert_id: @concert[:id],
        user_id: session["user_id"],
        comments: params["comments"],
        score: params["score"],
    )

    redirect "/concerts/#{@concert[:id]}"
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    puts params
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(name: params["name"], city: params["city"], email: params["email"], password: hashed_password)
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    user = users_table.where(email: params["email"]).to_a[0]
    puts BCrypt::Password::new(user[:password])
    if user && BCrypt::Password::new(user[:password]) == params["password"]
        session["user_id"] = user[:id]
        @current_user = user
        view "create_login"
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    @current_user = nil
    view "logout"
end
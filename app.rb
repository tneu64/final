# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

concerts_table = DB.from(:concerts)
reviews_table = DB.from(:reviews)

# need to add a route (/ is the home):
get "/" do # this is the index route
    puts "params: #{params}" #for debugging; only prints to console
    
    pp concerts_table.all.to_a #get all data from concert table (copied from sequel cheatsheet)
     # list the concert using loop
    @concerts = concerts_table.all.to_a # first, store events in a var; next add loop to events.erb
    
    view "concerts"
end

get "/concerts/:id" do # show route
    puts "params: #{params}"

    pp concerts_table.where(id: params["id"]).to_a[0] # copied from sequel cheatsheet, changed 1 to params[] to make it dynamic
    @concert = concerts_table.where(id: params["id"]).to_a[0]
    view "concert"
end

# add the form route to create new associated thing
get "/concerts/:id/reviews/new" do
    puts "params: #{params}"

    @concert = concerts_table.where(id: params["id"]).to_a[0]
    view "new_review"
end
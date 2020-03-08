# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :concerts do # this is my "places" model
  primary_key :id
  String :title
  String :conductor
  String :orchestra
  String :description, text: true
  String :date
  String :location
end

DB.create_table! :reviews do # model associated to place
  primary_key :id
  foreign_key :concerts_id
  #foreign_key :user_id
  String :name
  String :email
  String :comments, text: true #longer text 
  String :location
end
#DB.create_table! :user do
 #   primary_key :id
#end   
# Insert initial (seed) data
concerts_table = DB.from(:concerts)

concerts_table.insert(title: "Muti Conducts Beethoven 1 & 3", 
                    conductor: "Riccardo Muti",
                    orchestra: "Chicago Symphony Orchestra",
                    description: "See title",
                    date: "September 28, 2019",
                    location: "Symphony Center, Orchestra Hall, Chicago")

concerts_table.insert(title: "Muti Conducts Beethoven 4 & 7", 
                    conductor: "Riccardo Muti",
                    orchestra: "Chicago Symphony Orchestra",
                    description: "See title",
                    date: "April 30, 2020",
                    location: "Symphony Center, Orchestra Hall, Chicago")

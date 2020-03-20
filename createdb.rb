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
  foreign_key :concert_id
  foreign_key :user_id
  String :comments, text: true #longer text 
  Integer :score
end

DB.create_table! :users do
  primary_key :id
  String :name
  String :city
  String :email
  String :password
end

# Insert initial (seed) data
concerts_table = DB.from(:concerts)

concerts_table.insert(title: "Muti Conducts Beethoven 1 & 3", 
                    conductor: "Riccardo Muti",
                    orchestra: "Chicago Symphony Orchestra",
                    description: "Muti conducts the Chicago Symphony playing Beethoven's 1st and 3rd symphonies.",
                    date: "September 28, 2019",
                    location: "Symphony Center, Orchestra Hall, Chicago")

concerts_table.insert(title: "Concert in Paris - Ludwig van Beethoven Cycle II", 
                    conductor: "Andris Nelsons",
                    orchestra: "Wiener Philharmoniker",
                    description: "Andris Nelsons conducts the Vienna Philharmonic playing Beethoven's 4th and 5th symphonies",
                    date: "February 26, 2020",
                    location: "Théatre des Champs-Elysées, Paris, France")

require "twilio-ruby"                                                                 #

# testing Twilio
# Twilio setup
account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']

# set up a client to talk to the Twilio REST API
client = Twilio::REST::Client.new(account_sid, auth_token)

client.messages.create(
from: "+12057517149",
to: "+12039184323",
body: "Hey friend!"
)
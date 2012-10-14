#ruby hackNY.rb
#localtunnel 4567
#twilio copy and paste from
#Sap,a,b
require 'sinatra'
require 'twilio-ruby'
require './reminder'

Mongoid.load!("mongoid.yml")

# set up account details
@account_sid = 'AC5062036e8c86de58c91a5a8defd91d26'
@auth_token = 'ab4a6af3f955de235068517bad0d8a26'

# create a twilio client
client = Twilio::REST::Client.new(@account_sid, @auth_token)

# callback for SMS receive
post '/' do
  to = params["From"].to_s

  message = {:from => '+17328124972', 
             :to => to,  
             :body => 'Your text.'}

  @account = client.account
  @message = @account.sms.messages.create(message)
end

# Callback for when people visit the site from their browser
get '/' do
  "hello world"
end

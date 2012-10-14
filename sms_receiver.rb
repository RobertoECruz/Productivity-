#ruby hackNY.rb
#localtunnel 4567
#twilio copy and paste from
#Sap,a,b
require 'sinatra'
require 'twilio-ruby'
require './reminder'

Mongoid.load!("mongoid.yml")

# set up account details
@account_sid = 'AC6718c6ad289aa8356207c9bc0648ce85'
@auth_token = 'e2aa801278603e955176ffa1c963fe73'

# create a twilio client
client = Twilio::REST::Client.new(@account_sid, @auth_token)

# table for day of the week into a number
days = { sunday: 0,
         monday: 1,
         tuesday: 2,
         wednesday: 3,
         thursday: 4,
         friday: 5,
         saturday: 6 }

# protocol:
#   task on day of the week at time, day of the week at time, etc.

# day of the week must be monday, tuesday, wednesday, thursday, friday
# time must be an hour and must have either an am/pm or be in 24 hour format
def split_into_task_and_time(text)
  task_and_time = text.split(" on ")
  task_and_time[1] = task_and_time[1].scan(/(monday|tuesday|wednesday|thursday|friday) at (\d{1,2})(?:am|pm|)/)
  return task_and_time
end

# callback for SMS receive
get '/sms-hook' do
  p params
  
  t = split_into_task_and_time(params[:Body])

  t[1].each do |pair|
    r = Reminder.new({task: t[0],
                     day: days[pair[0].to_sym],
                     hour: pair[1].to_i},
                     phone: params[:From])

    puts r

    r.save!
  end
  
  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms "We'll remind you to #{t[0]}! Text back 'stop' to stop."
  end
  
  twiml.text
end

# Callback for when people visit the site from their browser
get '/' do
  "hello world"
end

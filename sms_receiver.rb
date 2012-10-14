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
post '/' do
  t_and_t = split_into_task_and_time(params["Body"])

  t_and_t[1].each do |pair|
    r = Reminder.new(task: t_and_t[0],
                     day: days[pair[0].to_sym],
                     hour: pair[1].to_i,
                     phone: params["From"])

    puts r

    r.save!
  end
end

# Callback for when people visit the site from their browser
get '/' do
  "hello world"
end

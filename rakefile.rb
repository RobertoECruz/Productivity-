require 'mongoid'
require 'twilio-ruby'
require './reminder'

Mongoid.load!("./mongoid.yml")

# set up account details
@account_sid = 'AC6718c6ad289aa8356207c9bc0648ce85'
@auth_token = 'e2aa801278603e955176ffa1c963fe73'

# create a twilio client
client = Twilio::REST::Client.new(@account_sid, @auth_token)

desc "This task will find all the users who have reminders set for the current hour and send them reminders"
task :send_reminders do
  now = Time.new

  reminders = Reminder.where(day: now.day, hour: now.hour).to_a
  reminders.each do |reminder|
    message = {:from => '+17328124972',
               :to => reminder.phone,
               :body => reminder.task }
    client.account.sms.messages.create(message)

    puts "told somebody to #{reminder.task}"
  end
end

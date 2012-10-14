require 'mongoid'
require 'twilio-ruby'
require './reminder'

Mongoid.load!("./mongoid.yml")

# set up account details
@account_sid = 'AC5062036e8c86de58c91a5a8defd91d26'
@auth_token = 'ab4a6af3f955de235068517bad0d8a26'

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

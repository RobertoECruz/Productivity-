require 'mongoid'

# This is a reminder document

# to save a reminder, create a new class and call save! on it.
# example:
#
#   r = Reminder.new(task: "Take out the trash", day: 1, hour: 20, phone: "9082173852")
#   r.save!

# Now the mongodb should save the reminder

# To get a reminder you query:
# example:
#
#   some_r = Reminder.where(day: 1, hour: 20).first

# this gets the first reminder that needs to be done on the 1'st day of the week
# and needs to be run on the 20th hour of the day.

# to get all of the reminders, for that day, replace ".first" with ".to_a"
# now you get an array of reminders

# example:
#
#   some_r_for_a_day = Reminder.where(day: 1, hour: 20).to_a

class Reminder
  include Mongoid::Document

  field :task, type: String, default: "get the milk"
  field :day, type: Integer, default: Time.now.day % 7
  field :hour, type: Integer, default: 8
  field :phone, type: String
end

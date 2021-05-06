# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/Users/nakumar/learnings/vaccine_slot_finder/config/cron_log.log"

# Need to run it every 40 mins to prevent api throttling.
every 10.minutes do
  command "vaccine_slot_finder '560067'"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

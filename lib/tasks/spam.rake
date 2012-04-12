require 'rake'
require 'openwfe/util/scheduler'
include OpenWFE

$LOAD_PATH << './lib'

require 'core/vk'

namespace :spam do

  desc "args: email, password, page, hash, message, count, interval"
  task :group do |t, args|

    require 'bots/group'

    # email, password, page, hash, message, count, interval
    
    email     = ENV['email']
    password  = ENV['password']
    page      = ENV['page']
    hash      = ENV['hash']
    message   = ENV['message']
    count     = ENV['count']
    interval  = ENV['interval']

    _message  = message.dup
    _message.gsub!(/\\n/,"\n")

    g_bot     = Bots::Group.new(email, password, page, hash, _message, count)
    p g_bot.initLogin
    if interval.to_i === 0
      g_bot.spam
    else
      scheduler = Scheduler.new
      scheduler.start
      scheduler.schedule_every(interval.to_s + "m") { g_bot.spam }
      scheduler.join
    end
  end

  desc "args: email, password, page, hash, message, count, interval"
  task :discussion do |t, args|

    require 'bots/discussion'

    # email, password, page, hash, message, times, interval
    
    email     = ENV['email']
    password  = ENV['password']
    page      = ENV['page']
    hash      = ENV['hash']
    message   = ENV['message']
    count     = ENV['count']
    interval  = ENV['interval']

    _message  = message.dup
    _message.gsub!(/\\n/,"\n")

    d_bot     = Bots::Discussion.new(email, password, page, hash, _message, count)
    if interval.to_i === 0
      d_bot.spam
    else
      scheduler = Scheduler.new
      scheduler.start
      scheduler.schedule_every(interval.to_s + "m") { d_bot.spam }
      scheduler.join
    end
  end
end

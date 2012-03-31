require 'rake'
require 'parseconfig'
require 'openwfe/util/scheduler'
include OpenWFE

$LOAD_PATH << './lib'

require 'core/bot'

namespace :spam do

  desc "args: email, password, page, hash, message, count, interval"
  task :group do |t, args|

    require 'bots/group'

    # email, password, page, hash, message, count, interval
    config    = ParseConfig.new('cfg/bot_cfg')
    g_config  = ParseConfig.new('cfg/bots/group_cfg')
    
    email     = ENV['email']    || config.get_value('email')
    password  = ENV['password'] || config.get_value('password')
    page      = ENV['page']     || g_config.get_value('page')
    hash      = ENV['hash']     || g_config.get_value('hash')
    message   = ENV['message']  || g_config.get_value('message')
    count     = ENV['count']    || g_config.get_value('count')
    interval  = ENV['interval'] || 0

    _message  = message.dup
    _message.gsub!(/\\n/,"\n")

    g_bot     = Bots::Group.new(email, password, page, hash, _message, count)

    if interval.to_i === 0
      g_bot.spam
    else
      scheduler = Scheduler.new
      scheduler.start
      scheduler.schedule_every(g_config.get_value('interval')) { g_bot.spam }
      scheduler.join
    end
  end

  desc "args: email, password, page, hash, message, count, interval"
  task :discussion do |t, args|

    require 'bots/discussion'

    # email, password, page, hash, message, times, interval
    config    = ParseConfig.new('cfg/bot_cfg')
    d_config  = ParseConfig.new('cfg/bots/discussion_cfg')
    
    email     = ENV['email']    || config.get_value('email')
    password  = ENV['password'] || config.get_value('password')
    page      = ENV['page']     || d_config.get_value('page')
    hash      = ENV['hash']     || d_config.get_value('hash')
    message   = ENV['message']  || d_config.get_value('message')
    count     = ENV['count']    || d_config.get_value('count')
    interval  = ENV['interval'] || 0

    _message  = message.dup
    _message.gsub!(/\\n/,"\n")

    d_bot     = Bots::Discussion.new(email, password, page, hash, _message, count)
    if interval.to_i === 0
      d_bot.spam
    else
      scheduler = Scheduler.new
      scheduler.start
      scheduler.schedule_every(d_config.get_value('interval')) { d_bot.spam }
      scheduler.join
    end
  end
end

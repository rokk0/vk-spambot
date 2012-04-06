$LOAD_PATH << './lib'

require 'core/bot'
require 'bots/group'
require 'bots/discussion'

# email, password, page, hash, message, times, interval
email     = 'example@example.com'
password  = 'password'
page      = 'http://vk.com/club19150223'
hash      = '9c1c8307f8626074bf'
message   = 'test'
count     = 4
interval  = 0
group_bot = Bots::Group.new(email, password, page, hash, message, count, interval)
group_bot.spam

# simple test, delete this line WOBWOB
# one more test, now using fork & pull request
# suka commenty ne schitautsa za kommit
puts "wobwob"

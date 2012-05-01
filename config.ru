# This file is used by Rack-based servers to start the application.

require 'parseconfig'

require ::File.expand_path('../config/environment',  __FILE__)

$bot_config  = ParseConfig.new('cfg/bot_cfg')
$service_url = $bot_config.get_value('service_url')
$secret_key  = $bot_config.get_value('secret_key')

run VkSpambot::Application

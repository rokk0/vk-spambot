# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
VkSpambot::Application.initialize!

# Hide db output logging
ActiveRecord::Base.logger = nil

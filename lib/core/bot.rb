require 'mechanize'
require 'parseconfig'

module Core
  class Bot
    def initialize(email, password)
      @@config    = ParseConfig.new('cfg/bot_cfg')
      @@logged_in = false
      @email      = email
      @password   = password

      @@agent = Mechanize.new { |a|
        a.user_agent_alias = @@config.get_value('user_agent_alias')
        #a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      }
    end

    def login
      @@agent.get(@@config.get_value('login_page')) do |login_page|
        login_form        = login_page.forms.first
        login_form.email  = @email
        login_form.pass   = @password

        login_form.submit
        @@logged_in = not(@@agent.get(@@config.get_value('login_page')).link_with(:id => 'logout_link').nil?)
      end
      abort('Login error') unless @@logged_in
    end
  end
end

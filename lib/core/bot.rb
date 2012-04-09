require 'mechanize'
require 'parseconfig'

module Core
  class Bot
    def initialize(email, password, phone)
      @@config      = ParseConfig.new('cfg/bot_cfg')
      @@logged_in   = false
      @@login_state = nil
      @email        = email
      @password     = password
      @phone        = phone

      @@agent = Mechanize.new { |a|
        a.user_agent_alias = @@config.get_value('user_agent_alias')
        a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      }
    end

    def login
      @@agent.get(@@config.get_value('home_page')) do |home_page|
        login_form        = home_page.forms.first
        login_form.email  = @email
        login_form.pass   = @password
        login_form.submit

        checkLogin
      end
    end

    def checkLogin
      @home_page    = @@agent.get(@@config.get_value('home_page'))
      @logout_link  = @home_page.link_with(:id => 'logout_link')

      loginSecurity unless @phone.nil?

      @@login_state = 'login_ok'
      @@login_state = 'login_error' if @logout_link.nil?
      @@login_state = 'login_ip_error' unless @home_page.uri.to_s.match(/security_check/).nil?

      @@logged_in   = @@login_state == 'login_ok'
    end

    def loggedIn
      @@logged_in
    end

    def loginState
      @@login_state
    end

    # phone - last 4 numbers of phone
    def loginSecurity
      params = {
        :act  => 'security_check',
        :code => @phone,
        :to   => @home_page.uri.to_s.match(/to=([^.]*)&/).to_s,
        :hash => @logout_link.to_s.match(/hash=([^.]*)&/).to_s
      }

      @@agent.post("http://vk.com/login.php", params)
    end
  end
end

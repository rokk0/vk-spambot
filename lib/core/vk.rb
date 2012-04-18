require 'mechanize'
require 'parseconfig'

module Core
  class Vk
    def initialize(email, password, code)
      @@logged_in   = false
      @@login_state = nil

      @config       = ParseConfig.new('cfg/bot_cfg')
      @email        = email
      @password     = password
      @code         = code

      @@agent = Mechanize.new do |a|
        a.user_agent_alias = @config.get_value('user_agent_alias')
        a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        a.pre_connect_hooks << lambda{|agent, request|
          request['X-Requested-With'] = 'XMLHttpRequest'
        }
      end
    end

    def logged_in?
      @@logged_in
    end

    def login_state
      @@login_state
    end

    def login
      @@agent.get(@config.get_value('home_page')) do |home_page|
        login_form        = home_page.forms.first
        login_form.email  = @email
        login_form.pass   = @password
        login_form.submit

        check_login
      end
    end

    def check_login
      home_page     = login_security
      logout_link   = home_page.link_with(:id => 'logout_link')

      @@login_state = 'login_ok'
      @@login_state = 'login_error' if logout_link.nil?
      @@login_state = 'login_ip_error' unless home_page.uri.to_s.match(/security_check/).nil?

      @@logged_in   = @@login_state == 'login_ok'
    end

    def check_captcha(body)
      #8766<!><!>3<!>3323<!>2<!>877498584665<!>0 - eng captcha
      #8766<!><!>3<!>3323<!>2<!>811148188578<!>1 - rus captcha
      @@login_state = 'eng_captcha' if body.match(/\d+<!><!>\d+<!>\d+<!>\d+<!>\d+<!>0/)
      @@login_state = 'rus_captcha' if body.match(/\d+<!><!>\d+<!>\d+<!>\d+<!>\d+<!>1/)
    end

    # code - last 4 didgits of a phone number
    def login_security
      home_page = @@agent.get(@config.get_value('home_page'))

      if !@code.nil?
        parse_page(home_page, /hash:\s'([^.]\w*)'/)
        params = {
          :act  => 'security_check',
          :code => @code,
          :to   => home_page.uri.to_s.match(/to=([^.]*)&/).to_s,
          :hash => @hash
        }
        @hash = nil

        return @@agent.post('http://vk.com/login.php', params)
      else
        return home_page
      end
    end

    def parse_page(page, regexp)
      page.search('script').each do |script|
        script.content.match(regexp)
        @hash ||= $1
      end
      @hash
    end

  end
end

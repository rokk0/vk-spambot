require 'mechanize'
require 'parseconfig'

module Core
  class Vk
    def initialize(email, password, phone)
      @@logged_in   = false
      @@login_state = nil

      @config       = ParseConfig.new('cfg/bot_cfg')
      @email        = email
      @password     = password
      @phone        = phone

      @@agent = Mechanize.new do |a|
        a.user_agent_alias = @config.get_value('user_agent_alias')
        a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    def logged_in
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
      #@home_page    = @@agent.get(@config.get_value('home_page'))
      home_page     = login_security
      logout_link   = home_page.link_with(:id => 'logout_link')

      @@login_state = 'login_ok'
      @@login_state = 'login_error' if logout_link.nil?
      @@login_state = 'login_ip_error' unless home_page.uri.to_s.match(/security_check/).nil?

      @@logged_in   = @@login_state == 'login_ok'
    end

    def get_hash(id, regexp)
      bot  = Bot.find(id)
      page = @@agent.get(bot.page)

      parse_page(page, regexp)

      bot.update_attributes(:page_hash => @hash)

      @hash
    rescue
      nil
    end

    def parse_page(page, regexp)
      page.search('script').each do |script|
        script.content.match(regexp)
        @hash ||= $1
      end
    end

    # phone - last 4 numbers of phone
    def login_security
      home_page = @@agent.get(@config.get_value('home_page'))

      if !@phone.nil?
        parse_page(home_page, /hash: '([^.]\w*)'/)
        params = {
          :act  => 'security_check',
          :code => @phone,
          :to   => home_page.uri.to_s.match(/to=([^.]*)&/).to_s,
          :hash => @hash
        }

        return @@agent.post('http://vk.com/login.php', params)
      else
        return home_page
      end
    end

  end
end

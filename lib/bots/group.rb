module Bots
  class Group < Core::Bot
    def initialize(email, password, page, hash, message, count)
      @bot = Core::Bot.new(email, password)

      @count      = (1..8).member?(count.to_i) ? count.to_i : 1
      @group_id   = '-' + page[/\d+/].to_s
      @hash       = hash
      @message    = message
      @msg_count  = 0
    end

    def initLogin
      return @bot.login
    end

    def spam
      params = {
        :act             => "post",
        :hash            => @hash,
        :facebook_export => "",
        :friends_only    => "",
        :note_title      => "",
        :official        => "",
        :signed          => "",
        :status_export   => "",
        :type            => "all",
        :message         => @message,
        :to_id           => @group_id
      }
      @count.times do
        @msg_count += 1
        p 'Sending group message #' + @msg_count.to_s
        params[:message] = @message + "\n\n" + rand(1000000000..9999999999).to_s
        @@agent.post('http://vk.com/al_wall.php', params)
      end if @@logged_in
    end
  end
end

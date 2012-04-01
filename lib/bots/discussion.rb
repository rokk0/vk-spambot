module Bots
  class Discussion < Core::Bot
    def initialize(email, password, page, hash, message, count)
      @bot = Core::Bot.new(email, password)

      @count          = (1..8).member?(count.to_i) ? count.to_i : 1
      @discussion_id  = '-' + page[/\d+_\d+/].to_s
      @hash           = hash
      @message        = message
      @msg_count      = 0
    end

    def initLogin
      return @bot.login
    end

    def spam
      params = {
        :act     => "post_comment",
        :topic   => @discussion_id,
        :hash    => @hash,
        :comment => @message
      }
      @count.times do
        @msg_count += 1
        p 'Sending discussion message #' + @msg_count.to_s
        params[:comment] = @message + "\n\n" + (rand(9999999999) + 100000000).to_s
        @@agent.post('http://vk.com/al_board.php', params)
      end if @@logged_in
    end
  end
end

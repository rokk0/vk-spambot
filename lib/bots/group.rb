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
        "act"             => "post",
        "hash"            => @hash.strip,
        "type"            => "all",
        "message"         => @message,
        "to_id"           => @group_id
      }
      @count.times do
        @msg_count += 1
        p 'Sending group message #' + @msg_count.to_s
        params["message"] = @message + "\n\n" + (rand(9999999999) + 100000000).to_s
        p params
        @@agent.post('http://vk.com/al_wall.php', params)
      end if @@logged_in
    end
  end
end

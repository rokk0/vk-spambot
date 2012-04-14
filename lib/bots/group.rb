module Bots
  class Group < Core::Vk
    def initialize(id, email, password, page, hash, message, count, code)
      @vk = Core::Vk.new(email, password, code)

      @count      = (1..8).member?(count.to_i) ? count.to_i : 1
      @group_id   = '-' + page[/\d+/].to_s
      @hash       = hash
      @message    = message
      @msg_count  = 0

      @vk.login

      @hash = @vk.get_hash(id, /"post_hash":"([^.]\w*)"/) if @hash.to_s.empty?
    end

    def spam
      params = {
        :act      => 'post',
        :hash     => @hash,
        :type     => 'all',
        :message  => @message,
        :to_id    => @group_id
      }

      @count.times do
        @msg_count += 1
        p 'Sending group message #' << @msg_count.to_s
        params[:message] = "#{@message}\n\n#{(rand(9999999999) + 100000000)}"
        @@agent.post('http://vk.com/al_wall.php', params)
      end if @@logged_in
    end

  end
end

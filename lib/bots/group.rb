module Bots
  class Group < Core::Vk
    def initialize(id, email, password, page, hash, message, count, code)
      @vk = Core::Vk.new(email, password, code)

      @count      = (1..8).member?(count.to_i) ? count.to_i : 1
      @page       = page
      @group_id   = '-' + page[/\d+/].to_s
      @hash       = hash
      @message    = message
      @msg_count  = 0

      @vk.login
    end

    def get_hash(page)
      page = @@agent.get(page)

      @hash = @vk.parse_page(page, /"post_hash":"([^.]\w*)"/)
    end

    def spam
      params = {
        :act      => 'post',
        :hash     => @hash,
        :type     => 'all',
        :message  => @message,
        :to_id    => @group_id,
        :al       => '1'
      }

      @count.times do
        @msg_count += 1
        p 'Sending group message #' << @msg_count.to_s
        params[:message] = "#{@message}\n\n#{(rand(9999999999) + 100000000)}"
        page = @@agent.post('http://vk.com/al_wall.php', params, { 'Referer' => @page })
        @vk.check_captcha(page.body)
      end if @@logged_in
    end

  end
end

module Bots
  class Discussion < Core::Vk
    def initialize(id, email, password, page, hash, message, count, code)
      @vk = Core::Vk.new(email, password, code)

      @count          = (1..8).member?(count.to_i) ? count.to_i : 1
      @page           = page
      @discussion_id  = '-' + page[/\d+_\d+/].to_s
      @hash           = hash
      @message        = message
      @msg_count      = 0

      @vk.login
    end

    def get_hash(page)
      page = @@agent.get(page)

      @hash = @vk.parse_page(page, /hash:\s'([^.]\w*)'/)
    end

    def spam
      params = {
        :act      => 'post_comment',
        :topic    => @discussion_id,
        :hash     => @hash,
        :comment  => @message,
        :al       => '1'
      }

      @count.times do
        @msg_count += 1
        p 'Sending discussion message #' << @msg_count.to_s
        params[:comment] = "#{@message}\n\n#{(rand(9999999999) + 100000000)}"
        page = @@agent.post('http://vk.com/al_board.php', params, { 'Referer' => @page })
        @vk.check_captcha(page.body)
      end if @@logged_in
    end

  end
end

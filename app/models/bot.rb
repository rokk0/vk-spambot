class Bot < ActiveRecord::Base
  attr_accessible :user_id, :email, :password, :bot_type, :page, :page_title, :page_hash, :message, :count, :hours, :minutes, :code
  attr_accessor :hours, :minutes

  belongs_to :user

  self.per_page = 10

  validates :password,  :presence     => true,
                        :confirmation => false,
                        :length       => { :within => 6..40 },
                        :if           => :validate_password?

  validates :email,     :presence     => true
  validates :bot_type,  :presence     => true
  validates :page,      :presence     => true
  validates :message,   :presence     => true
  validates :count,     :presence     => true
  validates :hours,     :presence     => true
  validates :minutes,   :presence     => true

  validates :bot_type, :inclusion     => { :in => %w{ group discussion }, :message => 'can only be group/duiscussion.' }

  validates :count, :numericality     => { :only_integer => true, :message => 'can only be whole number.' }
  validates :count, :inclusion        => { :in => 1..8, :message => 'can only be between 1 and 8.' }

  validates :hours, :numericality     => { :only_integer => true, :message => 'can only be whole number.' }
  validates :hours, :numericality     => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 24, :message => 'can only be between 0 and 24.' }

  validates :minutes, :numericality   => { :only_integer => true, :message => 'can only be whole number.' }
  validates :minutes, :numericality   => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60, :message => 'can only be between 0 and 60.' }

  validates :code, :numericality      => { :only_integer => true, :message => 'can only be whole number.' }
  validates :code, :length            => { :is => 4, :message => 'length must be 4 digits.' }

  default_scope :order => 'bots.created_at DESC'

  before_save :check_password, :set_interval

  # Go, go, go!
  def run
    data = {}
    bot_data = attributes.except("created_at", "updated_at")
    bot_data.each_pair { |k,v| data.store(k.to_sym,v.to_s) }

    data = { :bot => Encryptor.encrypt(data.to_json, :key => $secret_key) }

    response = RestClient.post "#{$service_url}/api/bot/run", data, { :content_type => :json, :accept => :json }
    update_title_and_hash(response)
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  # Trying to stop the bot in our sinatra part
  def stop
    data = { :bot => Encryptor.encrypt({:id => id}.to_json, :key => $secret_key) }
    RestClient.post "#{$service_url}/api/bot/stop", data, { :content_type => :json, :accept => :json }
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  # We need to update our db entry with data that returned from sinatra
  def update_title_and_hash(response)
    response = JSON.parse(response)

    page_title = response['page_title']
    unless page_title.nil?
      update_attribute(:page_title, page_title)
    end

    page_hash = response['page_hash']
    unless page_hash.nil?
      update_attribute(:page_hash, page_hash)
    end

    response
  end

  private

    def validate_password?
      new_record? || !password.blank?
    end

    def check_password
      self.password = Bot.find(id).password if password.blank?
    end

    def set_interval
      self.interval = hours.to_i.zero? && minutes.to_i.zero? ? 0 : "#{hours}h#{minutes}m" unless hours.nil? || minutes.nil?
    end

end

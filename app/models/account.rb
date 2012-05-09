class Account < ActiveRecord::Base
  resourcify

  attr_accessible :phone, :password, :user_id

  belongs_to :user
  has_many :bots, :dependent => :destroy

  self.per_page = 10

  auto_strip_attributes :phone

  phone_regex = /^\+\d+$/

  validates :password,  :presence     => true,
                        :confirmation => false,
                        :length       => { :within => 1..40 },
                        :if           => :validate_password?

  validates :phone,     :presence     => true,
                        :format       => { :with => phone_regex },
                        :uniqueness   => true

  default_scope :order => 'accounts.created_at DESC'

  before_save :check_password
  before_validation :check_account

  # Trying to run all user account bots in our sinatra part
  def run_bots
    statuses     = { id => {} }
    working_bots = Bot.check_status(user_id)

    session            = check_session['session']
    statuses[id][:all] = { :status => :error, :message => 'invalid login/password' } unless session

    bots.each do |bot|
      statuses[id][bot.id] = working_bots[bot.id.to_s].nil? ? bot.run : { :status => :info, :message => 'already running' }
    end if session

    statuses
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  # Trying to stop all user account bots in our sinatra part
  def stop_bots
    data = { :account => Encryptor.encrypt({:account_id => id}.to_json, :key => $secret_key) }
    RestClient.post "#{$service_url}/api/bot/stop_account_bots", data, { :content_type => :json, :accept => :json }
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  # Check existance of global variable with VK account session on service
  def check_session
    data = { :account => Encryptor.encrypt({:id => id, :phone => phone, :password => password}.to_json, :key => $secret_key) }

    response = RestClient.post "#{$service_url}/api/account/check_session", data, { :content_type => :json, :accept => :json }

    JSON.parse(response)
  rescue => error
    { :session => false }
  end
  
  private

    def validate_password?
      new_record? || !password.blank?
    end

    def check_password
      self.password = Account.find(id).password if password.blank?
    end

    def check_account
      data = {}
      account_data = attributes.except("created_at", "updated_at")
      account_data.each_pair { |k,v| data.store(k.to_sym,v.to_s) }

      data = { :account => Encryptor.encrypt(data.to_json, :key => $secret_key) }

      response = RestClient.post "#{$service_url}/api/account/approve", data, { :content_type => :json, :accept => :json }

      #errors.add(:phone, 'not approved') unless (JSON.parse(response)['status'] == 'ok')
    rescue
      errors.add(:phone, 'not approved')
    end

end

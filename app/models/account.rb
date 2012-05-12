require 'eventmachine'
require 'em-http-request'

class Account < ActiveRecord::Base
  resourcify

  attr_accessible :phone, :password, :code, :user_id

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

  validates :code,      :presence     => true,
                        :numericality => { :only_integer => true, :message => 'can only be whole number.' },
                        :length       => { :is => 4, :message => 'length must be 4 digits.' }

  default_scope :order => 'accounts.created_at DESC'

  before_validation :check_account

  before_save :check_password

  # Trying to run all user account bots in our sinatra part
  def run_bots(working_bots = nil)
    statuses       = { id => {} }
    working_bots ||= Bot.check_status(user_id)
    session        = check_session['session']
    request_data   = {}

    bots.each do |bot|
      if session
        if working_bots[bot.id.to_s].nil?
          # Collect each bot data
          request_data[bot.id] = bot.get_request_data
        else
          # Return old status if bot already running
          statuses[id][bot.id] = working_bots[bot.id.to_s]
        end
      else
        statuses[id][bot.id] = { :status => :error, :message => 'invalid login/password' }
      end
    end

    # Collect responses from EM MultiRequest
    statuses[id].merge!(run_multi_request(request_data))

    statuses
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  # Initializing EventMachine with MultiRequest to grab responses asynchronously
  def run_multi_request(request_data = {})
    statuses = {}

    unless request_data.empty?
      EventMachine.run do
        multi = EventMachine::MultiRequest.new

        request_data.each do |bot_id, data|
          # add multiple requests to the multi-handler 
          http = EventMachine::HttpRequest.new("#{$service_url}/api/bot/run")
          post = http.post :body => data
          multi.add(post)
        end

        multi.callback do
          multi.responses[:succeeded].each do |resp|
            # Parse each response from service
            response = JSON.parse(resp.response)
            statuses[response['bot_id']] = response.reject { |k| k == 'bot_id' }
          end
          #p multi.responses[:failed]

          EventMachine.stop
        end
      end
    end

    statuses
  rescue
    {}
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
    data = { :account => Encryptor.encrypt({:id => id, :phone => phone, :password => password, :code => code}.to_json, :key => $secret_key) }

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
      account_data = attributes.except('created_at', 'updated_at')
      account_data.each_pair { |k,v| data.store(k.to_sym,v.to_s) }

      data = { :account => Encryptor.encrypt(data.to_json, :key => $secret_key) }

      response = RestClient.post "#{$service_url}/api/account/approve", data, { :content_type => :json, :accept => :json }
      parsed_response = JSON.parse(response)

      # TODO: refactor,probably move this to separate function
      self.username = parsed_response['vk_username']
      self.link = parsed_response['vk_profile_link']

      errors.add(:phone, "not approved (#{parsed_response['message']})") unless (parsed_response['status'] == 'ok')
    rescue
      errors.add(:phone, 'not approved')
    end

end

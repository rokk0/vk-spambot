class Account < ActiveRecord::Base
  attr_accessible :code, :email, :password, :user_id

  belongs_to :user
  has_many :bots, :dependent => :destroy

  self.per_page = 10

  auto_strip_attributes :email

  validates :password,  :presence     => true,
                        :confirmation => false,
                        :length       => { :within => 6..40 },
                        :if           => :validate_password?

  validates :email,     :presence     => true

  validates :code, :numericality      => { :only_integer => true, :message => 'can only be whole number.' }
  validates :code, :length            => { :is => 4, :message => 'length must be 4 digits.' }

  default_scope :order => 'accounts.created_at DESC'

  before_save :check_password
  before_validation :check_email, :check_account

  # Trying to run all user account bots in our sinatra part
  def run_bots
    statuses = {}

    bots.each do |bot|
      statuses[bot.id] = bot.run
    end

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

  private

    def validate_password?
      new_record? || !password.blank?
    end

    def check_password
      self.password = Account.find(id).password if password.blank?
    end

    def check_email
      # Find last 10 characters of email/phone
      phone = email[email.length-10..email.length] unless email.nil? || email.length < 10

      if email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        # Do nothing
      elsif phone =~ /\d{10}/
        email = phone
      else
        errors.add(:email, 'invalid email or phone')
      end

      errors.add(:email, 'has already been taken by other account') unless Account.find_by_email_and_approved(self.email, true).nil?
    end

    def check_account
      data = {}
      account_data = attributes.except("created_at", "updated_at")
      account_data.each_pair { |k,v| data.store(k.to_sym,v.to_s) }

      data = { :account => Encryptor.encrypt(data.to_json, :key => $secret_key) }

      response = RestClient.post "#{$service_url}/api/account/approve", data, { :content_type => :json, :accept => :json }
      approve_account(JSON.parse(response))
    rescue
      errors.add(:email, 'not approved')
    end

    def approve_account(response)
      if (response['status'] == 'ok')
        self.approved = true
      else
        errors.add(:email, 'not approved')
      end
    end

end

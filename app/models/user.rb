# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :accounts, :dependent => :destroy
  has_many :bots, :through => :accounts, :dependent => :destroy

  self.per_page = 10

  auto_strip_attributes :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }

  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 },
                       :if           => :validate_password?

  default_scope :order => 'users.created_at DESC'

  before_save :encrypt_password

  # Trying to run all user bots in our sinatra part
  def run_bots
    statuses      = {}
    working_bots  = JSON.parse(Bot.check_status(id))

    accounts.each do |account|
      session                    = account.check_session['session']
      statuses[account.id]       = {}
      statuses[account.id][:all] = { :status => :error, :message => 'invalid login/password' } unless session

      account.bots.each do |bot|
        statuses[account.id][bot.id] = working_bots[bot.id.to_s].nil? ? bot.run : { :status => :info, :message => 'already running' }
      end if session
    end

    statuses
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  # Trying to stop all user bots in our sinatra part
  def stop_bots
    data = { :user => Encryptor.encrypt({:user_id => id}.to_json, :key => $secret_key) }
    RestClient.post "#{$service_url}/api/bot/stop_user_bots", data, { :content_type => :json, :accept => :json }
  rescue => error
    { :status => :error, :message => error.to_s }
  end

  def validate_password?
    new_record? || !password.blank?
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) unless password.blank?
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

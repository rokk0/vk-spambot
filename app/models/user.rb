class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :trackable, :confirmable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :accounts, :dependent => :destroy
  has_many :bots, :through => :accounts, :dependent => :destroy

  self.per_page = 10

  auto_strip_attributes :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,      :presence     => true,
                        :length       => { :maximum => 50 }

  validates :email,     :presence     => true,
                        :format       => { :with => email_regex },
                        :uniqueness   => { :case_sensitive => false }

  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 },
                        :if           => :validate_password?

  default_scope :order => 'users.created_at DESC'

  # Get accounts where count of bots less than allowed and editable bot account.
  def get_valid_accounts(action, account_id)
    is_editing = (action == 'edit' || action == 'update')
    valid_accounts = is_editing ? [] : [['--select--', nil]]

    valid_accounts + accounts.map do |account|
      if (is_editing && account.id == account_id.to_i) || account.bots.count < account.bots_allowed
        [account.username.to_s.empty? ? account.phone : account.username, account.id]
      end
    end.compact
  end

  # Trying to run all user bots in our sinatra part
  def run_bots
    statuses     = {}
    working_bots = Bot.check_status(id)

    accounts.each do |account|
      statuses.merge!(account.run_bots(working_bots))
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
end

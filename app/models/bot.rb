class Bot < ActiveRecord::Base
  attr_accessible :user_id, :email, :password, :bot_type, :page, :page_hash, :message, :count, :interval, :code

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
  validates :interval,  :presence     => true

  validates :bot_type, :inclusion     => { :in => %w{ group discussion }, :message => 'can only be group/duiscussion.' }

  validates :count, :numericality     => { :only_integer => true, :message => 'can only be whole number.' }
  validates :count, :inclusion        => { :in => 1..8, :message => 'can only be between 1 and 8.' }

  validates :interval, :numericality  => { :only_integer => true, :message => 'can only be whole number.' }
  validates :interval, :numericality  => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60, :message => 'can only be between 0 and 60.' }

  validates :code, :numericality      => { :only_integer => true, :message => 'can only be whole number.' }
  validates :code, :length            => { :is => 4, :message => 'length must be 4 digits.' }

  default_scope :order => 'bots.created_at DESC'

  before_save :check_password

  private

    def validate_password?
      new_record? || !password.blank?
    end

    def check_password
      self.password = Bot.find(id).password if password.blank?
    end

end

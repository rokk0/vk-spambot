class Bot < ActiveRecord::Base
  attr_accessible :user_id, :email, :password, :bot_type, :page, :page_hash, :message, :count, :interval, :state

  belongs_to :user

  #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,     :presence     => true
                       #:format       => { :with => email_regex },
  validates :password,  :presence     => true,
                        :confirmation => false,
                        :length       => { :within => 6..40 }

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

  default_scope :order => 'bots.count DESC'

end

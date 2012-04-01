class Bot < ActiveRecord::Base
  attr_accessible :user_id, :email, :password, :bot_type, :page, :page_hash, :message, :count, :interval, :state

  belongs_to :user

  #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,     :presence     => true
                       #:format       => { :with => email_regex },
  validates :password,  :presence     => true,
                        :confirmation => false,
                        :length       => { :within => 6..40 }
  validates :bot_type,  :presence => true
  validates :page,      :presence => true
  validates :page_hash, :presence => true
  validates :message,   :presence => true
  validates :count,     :presence => true
  validates :interval,  :presence => true

  default_scope :order => 'bots.count DESC'

end

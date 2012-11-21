class Post < ActiveRecord::Base
  resourcify

  attr_accessible :content, :title
end

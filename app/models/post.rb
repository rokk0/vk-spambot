class Post < ActiveRecord::Base
  resourcify
  self.per_page = 5

  attr_accessible :content, :title
end

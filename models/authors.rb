class Author < ActiveRecord::Base
  has_many :versions
  has_many :comments
end

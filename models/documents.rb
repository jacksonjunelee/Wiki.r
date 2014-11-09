class Document < ActiveRecord::Base
  has_many :versions, dependent: :destroy
  has_many :comments, dependent: :destroy
end

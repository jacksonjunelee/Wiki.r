class Document < ActiveRecord::Base
  has_many :versions, dependent: :destroy
end

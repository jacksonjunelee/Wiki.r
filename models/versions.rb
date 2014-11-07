class Version < ActiveRecord::Base
  belongs_to_many :documents
  belongs_to_many :authors
end

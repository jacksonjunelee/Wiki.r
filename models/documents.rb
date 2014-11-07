class Document < ActiveRecord::Base
  has_many :versions
  has_and_belongs_to_many :authors
end

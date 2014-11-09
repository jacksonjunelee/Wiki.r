class Comment < ActiveRecord::Base
  belongs_to :documents
end

require 'active_record'

require_relative '../models/authors.rb'
require_relative '../models/versions.rb'
require_relative '../models/documents.rb'

ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'wiki_db',
})

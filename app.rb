require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'better_errors'
require 'pry'

#====Models====
require_relative 'models/authors.rb'
require_relative 'models/versions.rb'
require_relative 'models/documents.rb'


configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'wiki_db',
})

after { ActiveRecord::Base.connection.close }

      # =========
      #   Home
      # =========

get '/' do
  erb :'home/home'
end

      # =========
      #   Author
      # =========

get '/authors' do
  @authors = Author.all
  erb :'authors/index'
end

get '/authors/:id' do
  author = Author.find(:id)
  erb :'authors/show'
end

      # ============
      #   Document
      # =============

get '/documents' do
  @documents = Document.all
  erb :'documents/index'
end

get '/authors/:id' do
  author = Author.find(:id)
  erb :'authors/show'
end
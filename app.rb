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
# index
get '/authors' do
  @authors = Author.all
  erb :'authors/index'
end

# new
get '/authors/new' do
  erb :'authors/new'
end

post '/authors' do
  author = Author.new(params[:author])
  if author.save
    redirect("/authors/#{author.id}")
  else
    redirect("/authors/new")
  end
end

# show
get '/authors/:id' do
  @author = Author.find(params[:id])
  doc_id_array = @author.versions.map {|doc_id| doc_id.document_id}
  @documents = doc_id_array.map {|doc_id| Document.find(doc_id)}
  erb :'authors/show'
end


      # ============
      #   Document
      # =============

get '/documents' do
  @documents = Document.all
  erb :'documents/index'
end

get '/documents/new' do
  @author = Author.all
  erb :'documents/new'
end

get '/documents/:id' do
  @document = Document.find(params[:id])
  erb :'documents/show'
end

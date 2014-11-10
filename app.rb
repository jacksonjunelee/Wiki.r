require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'better_errors'
require 'pry'

#====Models====
require_relative 'models/authors.rb'
require_relative 'models/versions.rb'
require_relative 'models/documents.rb'
require_relative 'models/comments.rb'


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

#creation show
get '/' do
  versions = Version.all
  changes = versions.sort_by{|ver| ver[:v_date]}.reverse!
  @changes = changes[0..7]
  erb :'home/home'
end

# search bar
post "/" do
  @authors = Author.all
  @documents = Document.all
  input = params[:search]
  search_wiki = input[:search].downcase
  $au_search = @authors.find {|author_search| author_search.username.downcase == search_wiki}
  $doc_search =@documents.find {|doc_search| doc_search.title.downcase == search_wiki}
  redirect("/search_results")
end
# Author.all.find {|author_search| author_search.username == "Moo"}

#search results
get '/search_results' do
  $au_search
  $doc_search
  erb :search
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

# index
get '/documents' do
  @documents = Document.all
  erb :'documents/index'
end

# new
get '/documents/new' do
  @author = Author.all
  erb :'documents/new'
end

post '/documents' do
  document = Document.create(params[:document])
  version = Version.new(params[:version])
  version.document = document
  if version.save
    redirect("/documents/#{document.id}")
  else
    redirect("/documents/new")
  end
end


# show
get '/documents/:id' do
  @document = Document.find(params[:id])
  @content = @document.versions.sort_by{|ver| ver[:v_date]}.reverse!
  # @content = content.first
  # @author = @content.first.author.username
  erb :'documents/show'
end

# edit and update
get '/documents/:id/edit' do
  @document = Document.find(params[:id])
  @authors = Author.all
  erb :'documents/edit'
end

put '/documents/:id' do
  document = Document.find(params[:id])
	version = Version.new(params[:version])
  version.document = Document.find(params[:id])
	if version.save
		redirect("/documents/#{document.id}")
	else
		redirect("/documents")
	end
end

#destroy

delete '/documents/:id' do
  document = Document.find(params[:id])
  document.destroy
  if document.destroy
    redirect("/documents")
  else
    redirect("/documents/#{document.id}")
  end
end

# show past versions of documents

get '/documents/:id/previous_versions' do
  @document = Document.find(params[:id])
  @content = @document.versions.sort_by{|ver| ver[:v_date]}.reverse!
  @pre_ver = @content[1..-1]
  erb :'documents/previous_versions'
end


get '/documents/:id/previous_versions/:var' do
  @document = Document.find(params[:id])
  @content = @document.versions.sort_by{|ver| ver[:v_date]}.reverse!
  var = params[:var]
  @show_pre_ver = @content.find {|ver| ver.id == var.to_i}
  erb :'documents/pre_ver_show'
end
# Document.find(1).versions.find {|ver| ver.id == 10}
# 7?

# show discussions page and make new comments

get '/documents/:id/discussions' do
  @authors = Author.all
  @document = Document.find(params[:id])
  @comments = @document.comments.sort_by{|ver| ver[:c_date]}.reverse!
  erb :'documents/discussions'
end

post '/documents/:id' do
  @document = Document.find(params[:id])
  comment = Comment.new(params[:comment]) #make new comment
  comment.document = @document
  comment.save
  redirect("/documents/#{@document.id}/discussions")
end

binding.pry

      # ============
      #   Comments
      # =============

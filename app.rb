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
	database: 'jackson_wiki',
})

after { ActiveRecord::Base.connection.close }

      # =========
      #   Home
      # =========

#index , show recent changes, show new create documents
get '/' do
  versions = Version.all
  changes = versions.sort_by{|ver| ver[:updated_at]}.reverse!
  @changes = changes[0..7]
  document = Document.all
  new_docs = document.sort_by{|new_updated| new_updated[:updated_at]}.reverse!
  @new_docs = new_docs[0..7]
  erb :'home/home'
end

# search bar
post "/" do
  @authors = Author.all.order('username')
  @documents = Document.all.order('title')
  @versions = Version.all
  input = params[:search]
  search_wiki = input[:search].downcase
  $doc_search = @documents.map {|doc| doc if doc.title.downcase.include?(search_wiki)}
  $au_search = @authors.map { |au| au if au.username.downcase.include?(search_wiki)}
  $version_search =@versions.map {|version| version if version.blurb.downcase.include?(search_wiki) || version.content.downcase.include?(search_wiki)}
  # $doc_search= Document.all.map {|doc| doc if doc.title.downcase.include?("p")}
  # $doc_search= @documents.find { |doc_search| doc_search.title.downcase.include?(search_wiki)}
  # $doc_search= Document.all.find {:all, :conditions => :title.downcase => search_wiki}
  # $au_search = @authors.find {|author_search| author_search.username.downcase.include?(search_wiki)}
  # $doc_search =@documents.find {|doc_search| doc_search.title.downcase == search_wiki}
  # Document.all.find {|doc_search| doc_search.title.downcase == ("p")}
  redirect("/search_results")
end
# Author.all.find {|author_search| author_search.username == "Moo"}

#search results
get '/search_results' do
  @authors = Author.all.order('username')
  @documents = Document.all.order('title')
  @versions = Version.all

  input = params[:search]
  search_wiki = input[:search].downcase
  doc_search = @documents.map {|doc| doc if doc.title.downcase.include?(search_wiki)}
  au_search = @authors.map { |au| au if au.username.downcase.include?(search_wiki)}
  version_search =@versions.map {|version| version if version.blurb.downcase.include?(search_wiki) || version.content.downcase.include?(search_wiki)}

  @doc = []
  @au = []
  @version = []

  doc_search.each do |doc|
    @doc.push(doc.title) if doc != nil
  end
  au_search.each do |au|
    @au.push(au.username) if au != nil
  end
  version_search.each do |version|
    @version.push(version.document.title) if version != nil
  end
  
  erb :search
end

      # =========
      #   Author
      # =========
# index
get '/authors' do
  @authors = Author.all.order('username')
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
  @doc_list = @documents.uniq
  erb :'authors/show'
end

# edit
get '/authors/:id/edit' do
  @author = Author.find(params[:id])
  erb :'authors/edit'
end

put '/authors/:id' do
  author = Author.find(params[:id])
  if author.update(params[:author])
    redirect("/authors/#{author.id}")
  else
    redirect("/authors")
  end
end


      # ============
      #   Document
      # =============

# index
get '/documents' do
  @documents = Document.all.order('title')
  erb :'documents/index'
end

# new
get '/documents/new' do
  @author = Author.all.order('username')
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
  @content = @document.versions.sort_by{|ver| ver[:updated_at]}.reverse!
  # @content = content.first
  # @author = @content.first.author.username
  erb :'documents/show'
end

# edit and update
get '/documents/:id/edit' do
  @document = Document.find(params[:id])
  @authors = Author.all.order('username')
  content = @document.versions.sort_by{|ver| ver[:updated_at]}.reverse!
  @edit_content = content.first
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
  @content = @document.versions.sort_by{|ver| ver[:updated_at]}.reverse!
  @pre_ver = @content[1..-1]
  erb :'documents/previous_versions'
end


get '/documents/:id/previous_versions/:var' do
  @document = Document.find(params[:id])
  @content = @document.versions.sort_by{|ver| ver[:updated_at]}.reverse!
  var = params[:var]
  @show_pre_ver = @content.find {|ver| ver.id == var.to_i}
  erb :'documents/pre_ver_show'
end

# Revert

put '/documents/:id/previous_versions' do
  document = Document.find(params[:id])
  revert_document = Version.new(params[:revert_previous])
  if revert_document.save
    redirect("/documents/#{document.id}")
  else
    redirect("/documents/#{document_id}/previous_versions")
  end
end

# show discussions page and make new comments

get '/documents/:id/discussions' do
  @authors = Author.all
  @document = Document.find(params[:id])
  @comments = @document.comments.sort_by{|ver| ver[:updated_at]}.reverse!
  erb :'documents/discussions'
end

post '/documents/:id' do
  @document = Document.find(params[:id])
  comment = Comment.new(params[:comment]) #make new comment
  comment.document = @document
  comment.save
  redirect("/documents/#{@document.id}/discussions")
end


      # ============
      #   Comments
      # =============

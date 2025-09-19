# frozen_string_literal:true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

FILE_PATH = 'memos.json'

helpers do
  include ERB::Util
end

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

def set_memos(file_path, memos)
  File.write(file_path, memos.to_json)
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = get_memos(FILE_PATH)
  @id = params[:id]
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(FILE_PATH)
  id = ((memos.keys.map(&:to_i).max || 0) + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @id = params[:id]
  @memo = memos[@id]
  erb :edit
end

patch '/memos/:id' do
  memos = get_memos(FILE_PATH)
  id = params[:id]
  memos[id]['title'] = params[:title]
  memos[id]['content'] = params[:content]
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

not_found do
  erb :not_found
end

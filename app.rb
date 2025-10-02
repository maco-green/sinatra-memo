# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

FILE_PATH = 'memos.json'

helpers do
  include ERB::Util
end

def read_memos
  JSON.parse(File.read(FILE_PATH))
end

def write_memos(memos)
  File.write(FILE_PATH, memos.to_json)
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = read_memos
  @id = params[:id]
  @memo = memos[@id]
  halt 404, erb(:not_found) unless @memo

  @title = @memo['title']
  @content = @memo['content']
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  memos = read_memos
  id = ((memos.keys.map(&:to_i).max || 0) + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  write_memos(memos)

  redirect '/memos'
end

delete '/memos/:id' do
  memos = read_memos
  memos.delete(params[:id])
  write_memos(memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = read_memos
  @id = params[:id]
  @memo = memos[@id]
  halt 404, erb(:not_found) unless @memo
  erb :edit
end

patch '/memos/:id' do
  memos = read_memos
  id = params[:id]
  memo = memos[id]
  halt 404, erb(:not_found) unless memo

  memo['title'] = params[:title]
  memo['content'] = params[:content]
  write_memos(memos)

  redirect '/memos'
end

not_found do
  erb :not_found
end

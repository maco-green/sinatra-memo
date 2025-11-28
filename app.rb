# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pg'

DB = PG.connect(
  ENV['DATABASE_URL'] || { dbname: 'sinatra_memo_development' }
)

helpers do
  include ERB::Util
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = all_memos
  erb :index
end

def all_memos
  rows = DB.exec('SELECT id, title, content FROM memos ORDER BY id')

  memos = {}
  rows.each do |row|
    id = row['id']
    memos[id] = { 'title' => row['title'], 'content' => row['content'] }
  end

  memos
end

get '/memos/new' do
  erb :new
end

# TODO: find_memo(id)で1件取得する

get '/memos/:id' do
  @id = params[:id]
  @memo = find_memo(@id)
  halt 404, erb(:not_found) unless @memo

  @title = @memo['title']
  @content = @memo['content']
  erb :show
end

# TODO: DBからidのメモを1件取得する

def find_memo(id)
  DB.exec_params(
    'SELECT id, title, content FROM memos WHERE id = $1;',
    [id]
  ).first
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  create_memo(title, content)

  redirect '/memos'
end

def create_memo(title, content)
  DB.exec_params(
    'INSERT INTO memos (title, content) VALUES ($1, $2);',
    [title, content]
  )
end

delete '/memos/:id' do
  id = params[:id]
  delete_memo(id)
  redirect '/memos'
end

def delete_memo(id)
  DB.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memo = find_memo(@id)
  halt 404, erb(:not_found) unless @memo
  erb :edit
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:title]
  content = params[:content]

  halt 404, erb(:not_found) unless find_memo(id)

  update_memo(id, title, content)
  redirect '/memos'
end

def update_memo(id, title, content)
  DB.exec_params(
    'UPDATE memos SET title = $1, content = $2, updated_at = NOW() WHERE id = $3;',
    [title, content, id]
  )
end

not_found do
  erb :not_found
end

# frozen_string_literal:ture

require 'sinatra'
require 'json'


file_path = "public/memos.json"
@file_path = "public/memos.json"

@file_path = "aaaaaa.json"

FILE_PATH = 'public/memos.json'

def get_memos(file_path)
  f = File.open(file_path) 
  json_text = f.read
  JSON.parse(json_text)
end


get '/' do
  'Hello Sinatra Memo!'
end

# Sinatra Memo App

Sinatraを使ったメモアプリです

## 機能

メモの一覧表示、作成、編集、削除

## セットアップ

1. リポジトリをcloneする

```bash
git clone https://github.com/maco-green/sinatra-memo.git
```

2. ディレクトリに移動する

```bash
cd sinatra-memo
```

3. 依存関係をインストールする

```bash
bundle install
```

## データベースの準備

このアプリケーションでは PostgreSQLを使用しています

1. データベースを作成する

```bash
createdb sinatra_memo_development
```

2. テーブルを作成する

```bash
psql -d sinatra_memo_development -f db/ddl.sql
```

※db/ddl.sql には、memos テーブルを作成するためのDDL（CREATE TABLE文）が定義されています。

## 起動方法

1. アプリケーションを起動する

```bash
bundle exec ruby app.rb
```

2. ブラウザでアクセスする
http://localhost:4567


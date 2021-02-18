require_relative 'database'

class DatabaseMigration < Database
  require "pg"

  POST_IMAGES = "post_images"
  POSTS = "posts"
  USERS = "users"

  def set_up_tables
    @@conn.exec "create table #{POST_IMAGES} (
      id serial not null,
      post_id integer,
      file_path text,
      created_at timestamp,
      updated_at timestamp
    )"

    @@conn.exec "create table #{POSTS} (
      id serial not null,
      content text,
      post_user integer,
      created_at timestamp,
      updated_at timestamp
    )"

    @@conn.exec "create table #{USERS} (
      id serial not null,
      email text,
      password text,
      name text,
      created_at timestamp,
      updated_at timestamp
    )"
  end

  def drop_tables
    if tables_exist?
      drop = "drop table "
      @@conn.exec drop + POST_IMAGES
      @@conn.exec drop + POSTS
      @@conn.exec drop + USERS
    else
      "No tables to be dropped"
    end
  end

  def tables_exist?
    result = @@conn.exec "SELECT table_name FROM information_schema.tables where table_schema = 'public'"
    return result.values.empty? ? false : true
  end
end

if $0 == __FILE__
  db = DatabaseMigration.new
  p db.drop_tables
  p db.set_up_tables
end

require "sinatra"
require "bcrypt"
require "pg"
require "sinatra/reloader"
require "sinatra/cookies"
require "sinatra/flash"

require_relative "database/post_image.rb"
require_relative "database/post.rb"
require_relative "database/user.rb"

enable :sessions

get "/" do
  erb :index
end

get "/signup" do
  erb :signup
end

post "/signup" do
  user = User.new(
    email: params[:email],
    password: params[:password],
    name: params[:name]
  )

  if !user.validate
    flash[:error_messages] = user.error_messages
    redirect back
  end

  if !user.insert
    flash[:error_messages] = "ユーザーの作成に失敗しました"
    redirect back
  end

  session[:user] = user.params_columns

  erb :posts
end
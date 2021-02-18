require_relative "database"

class User < Database
  attr_accessor :email, :password, :name, :params_columns

  TABLE_NAME = "users"

  COLUMNS = {
    ID: "id",
    EMAIL: "email",
    PASSWORD: "password",
    NAME: "name",
    CREATED_AT: "created_at",
    UPDATED_AT: "updated_at",
  }

  def initialize(email: "", password: "", name: "")
    @email = email
    @password = password
    @name = name

    @params_columns = {
      email: @email,
      password: @password,
      name: @name
    }

    super(table: TABLE_NAME, params_columns: @params_columns)
  end

  def validate
    if @email.empty? || @password.empty? || @name.empty?
      @error_messages.push "未入力の項目があります"
    end

    if @password.length < 5
      @error_messages.push "パスワードが短すぎます"
    end

    if @error_messages.empty?
      return true
    else
      return false
    end
  end
end
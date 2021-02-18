require "pg"
require_relative "database_config"

class Database
  include DatabaseConfig

  attr_accessor :table, :error_messages

  DEFAULT_COLUMNS = ["id", "created_at", "updated_at"]

  def initialize(table: "", params_columns: {})
    @conn = PG::connect(
      host: DatabaseConfig::HOST,
      port: DatabaseConfig::PORT,
      dbname: DatabaseConfig::DBNAME,
      user: DatabaseConfig::USER,
      password: DatabaseConfig::PASSWORD,
    )

    @table = table
    @params_columns = params_columns
    @error_messages = []
  end

  def columns_exist?(columns: [])
    if !columns.instance_of?(Array) || columns.empty?
      p "KEIJIBAN ERROR: カラムの存在チェックでエラーが発生しました (table: #{self.table})"
      return false
    end
    columns.each do |column|
      if column != "*" && !self.class::COLUMNS.has_value?(column.to_s)
        p "KEIJIBAN ERROR: 存在しないカラムが指定されました (table: #{self.table}, column: #{column})"
        return false
      end
    end
    true
  end

  def select(columns: ["*"], where: {})
    return false if !columns_exist?(columns: columns)
    sql = sprintf "select %s from %s", columns.join(","), @table
    if where.any?
      parameters = []
      where.each_with_index do |(column, value), index|
        parameters.push("#{column} = $#{index+1}") # plus 1 の必要ある?
      end
      sql += " where " + parameters.join(" and ")
    end

    @conn.prepare "prepared", sql
    @conn.exec_prepared "prepared", where.values.empty? ? [] : where.values
  end

  def insert
    return false if !columns_exist?(columns: @params_columns.keys)

    columns = self.class::COLUMNS.values.select {|column| !DEFAULT_COLUMNS.include?(column)}

    return false if columns.length != @params_columns.length

    bind_params = []
    columns.length.times do |index|
      bind_params.push "$#{(index+1).to_s}"
    end
    sql = sprintf "insert into %s (%s) values (%s)", @table, columns.join(", "), bind_params.join(", ")

    @conn.prepare "prepared", sql
    @conn.exec_prepared "prepared", @params_columns.values
  end
end

if $0 == __FILE__
  require_relative "user"
  puts "test is being executed"
  user = User.new
  if user.insert(params: {email: "example@example.com", password: "pass", name: "Taro"})
    puts "inserted"
  else
    puts "failed"
  end
end
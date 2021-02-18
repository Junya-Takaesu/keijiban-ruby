=begin
テーブル(レコード？)を表すクラス、
データベースとのやり取りは、Database クラスを継承して行う
まだ実装も、テストしていない
=end
class Post < Database
  TABLE_NAME = "posts"

  COLUMNS = [
    ID: "id",
    CONTENT: "content",
    POST_USER: "post_user",
    CREATED_AT: "created_at",
    UPDATED_AT: "updated_at"
  ]

  def initialize()
    super(table: TABLE_NAME)
  end
end
require_relative "database"

class PostImage < Database
  TABLE_NAME = "post_images"

  COLUMNS = [
    ID: "id",
    POST_ID: "post_id",
    FILE_PATH: "file_path",
    CREATED_AT: "created_at",
    UPDATED_AT: "updated_at"
  ]

  def initialize()
    super(table: TABLE_NAME)
  end
end
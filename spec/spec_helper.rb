require "list"
require "task"
require "pg"

DB = PG.connect(:dbname => "to_do_test")

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM lists *;")
    DB.exec("ALTER SEQUENCE lists_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM tasks *;")
    DB.exec("ALTER SEQUENCE tasks_id_seq RESTART WITH 1;")
  end
end

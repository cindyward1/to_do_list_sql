class Task
  attr_reader :name, :list_id

  def initialize(attributes)
    @name = attributes[:name]
    @list_id = attributes[:list_id]
  end

  def self.all
    results = DB.exec("SELECT * from tasks;")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      tasks << Task.new({:name=>name, :list_id=>list_id})
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id) VALUES ('#{@name}', #{@list_id});")
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id == another_task.list_id
  end

end

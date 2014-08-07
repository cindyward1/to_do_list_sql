class Task
  attr_reader :name, :id, :list_id

  def initialize(attributes)
    @name = attributes[:name]
    @list_id = attributes[:list_id]
    @id = attributes[:id]
  end

  def self.all
    results = DB.exec("SELECT * from tasks;")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      id = result['id'].to_i
      tasks << Task.new({:name=>name, :id=>id, :list_id=>list_id})
    end
    tasks
  end

  def self.choice(current_list)
    results = DB.exec("SELECT * FROM tasks WHERE list_id = #{current_list.id};")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id']
      id = result['id'].to_i
      tasks << Task.new({:name=>name, :id=>id, :list_id=>list_id})
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id) VALUES ('#{@name}', #{@list_id});")
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id == another_task.list_id
  end

  def delete
    DB.exec("DELETE FROM tasks WHERE id = #{self.id};")
  end

end

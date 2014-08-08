class Task
  attr_reader :name, :id, :list_id, :completed, :due_date

  def initialize(attributes)
    @name = attributes[:name]
    @list_id = attributes[:list_id]
    @id = attributes[:id]
    @completed = attributes[:completed]
    @due_date = attributes[:due_date]
  end

  def self.all
    results = DB.exec("SELECT name, id, list_id, completed, TO_CHAR(due_date, 'MM/DD/YY') FROM tasks;")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      id = result['id'].to_i
      completed_string = result['completed']
      if completed_string == "t"
        completed = true
      else
        completed = false
      end
      due_date = result['to_char']
      tasks << Task.new({:name=>name, :id=>id, :list_id=>list_id, :completed=>completed,
                         :due_date=>due_date})
    end
    tasks
  end

  def self.choice(current_list)
    results = DB.exec("SELECT name, id, list_id, completed, TO_CHAR(due_date, 'MM/DD/YY') FROM tasks " +
                      "WHERE list_id = #{current_list.id};")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id']
      id = result['id'].to_i
      completed_string = result['completed']
      if completed_string == "t"
        completed = true
      else
        completed = false
      end
      due_date = result['to_char']
      tasks << Task.new({:name=>name, :id=>id, :list_id=>list_id, :completed=>completed, :due_date=>due_date})
    end
    tasks
  end

  def completed?
    @completed
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id, completed, due_date) VALUES ('#{@name}', #{@list_id}, " +
            "#{@completed}, TO_DATE('#{@due_date}','MM/DD/YYYY'));")
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id == another_task.list_id
  end

  def delete
    DB.exec("DELETE FROM tasks WHERE id = #{self.id};")
  end

  def mark_complete
    DB.exec("UPDATE tasks SET completed = true WHERE id = #{self.id};")
  end

end

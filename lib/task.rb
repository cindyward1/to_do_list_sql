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
    results = DB.exec("SELECT name, id, list_id, completed, TO_CHAR(due_date, 'MM/DD/YYYY') FROM tasks;")
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

  def self.choice_sorted(current_list,sort_direction)
    if sort_direction == "ASC" || sort_direction == "DESC"
      results = DB.exec("SELECT name, id, list_id, completed, TO_CHAR(due_date, 'MM/DD/YYYY') FROM tasks " +
                        "WHERE list_id = #{current_list.id} ORDER BY due_date #{sort_direction};")
    else
      results = DB.exec("SELECT name, id, list_id, completed, TO_CHAR(due_date, 'MM/DD/YYYY') FROM tasks " +
                      "WHERE list_id = #{current_list.id};")
    end
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
    @completed = true
    DB.exec("UPDATE tasks SET completed = true WHERE id = #{self.id};")
  end

  def update_name(new_task_name)
    @name = new_task_name
    DB.exec("UPDATE tasks SET name = '#{self.name}' WHERE id = #{self.id};")
  end

  def update_due_date(new_due_date)
    @due_date = new_due_date
    DB.exec("UPDATE tasks SET due_date = TO_DATE('#{@due_date}','MM/DD/YYYY') WHERE id = #{self.id};")
  end

end

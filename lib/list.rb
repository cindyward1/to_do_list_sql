class List

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    results = DB.exec("SELECT * FROM lists;")
    lists = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      lists << List.new({:name=>name, :id=>id})
    end
    lists
  end

  def save
    list = DB.exec("INSERT INTO lists (name) VALUES ('#{name}') RETURNING id;")
    @id = list.first['id'].to_i
  end

  def ==(another_list)
    self.name == another_list.name
  end

  def delete
    DB.exec("DELETE FROM tasks WHERE list_id = #{self.id}")
    DB.exec("DELETE FROM lists WHERE id = #{self.id};")
  end

end

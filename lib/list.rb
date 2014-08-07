class List

  attr_reader :name

  def initialize(attributes)
    @name = attributes[:name]
  end

  def self.all
    results = DB.exec("SELECT * FROM lists;")
    lists = []
    results.each do |result|
      name = result['name']
      lists << List.new({:name=>name})
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

end

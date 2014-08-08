require "spec_helper"

describe Task do
  it 'is initialized with a name, a list ID' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1, :completed=>false,
                          :due_date=>'08/31/2014'})
    expect(test_task).to be_an_instance_of Task
  end

  it 'tells you its name, list ID, its completion status, and its due date' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1, :completed=>false,
                          :due_date=>'08/31/2014'})
    expect(test_task.name).to eq 'Go to bed on time'
    expect(test_task.list_id).to eq 1
    expect(test_task.completed).to eq false
    expect(test_task.due_date).to eq '08/31/2014'
  end

  it 'is initialized as being not completed' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1, :completed=>false,
                          :due_date=>'08/31/2014'})
    expect(test_task.completed?).to eq false
  end

  it 'starts with an empty array' do
    expect(Task.all).to eq []
  end

  it 'saves a new task in an array' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1, :completed=>false,
                          :due_date=>'08/31/2014'})
    test_task.save
    expect(Task.all).to eq [test_task]
  end

  it 'has two tasks equal to each other if names and list IDs match' do
    test_task1 = Task.new({:name=>'Go to bed on time', :list_id=>1, :completed=>false,
                           :due_date=>'08/31/2014'})
    test_task2 = Task.new({:name=>'Go to bed on time', :list_id=>1, :completed=>false,
                           :due_date=>'08/31/2014'})
    expect(test_task1).to eq test_task2
  end

end

require "spec_helper"

describe Task do
  it 'is initialized with a name and a list ID' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1})
    expect(test_task).to be_an_instance_of Task
  end

  it 'tells you its name and list id' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1})
    expect(test_task.name).to eq 'Go to bed on time'
    expect(test_task.list_id).to eq 1
  end

  it 'starts with an empty array' do
    expect(Task.all).to eq []
  end

  it 'saves the a new task in an array' do
    test_task = Task.new({:name=>'Go to bed on time', :list_id=>1})
    test_task.save
    expect(Task.all).to eq [test_task]
  end

end

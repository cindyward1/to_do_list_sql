require "spec_helper"

describe List do
  it 'is initialized with a name and a list ID' do
    test_list = List.new({:name=>'Home'})
    expect(test_list).to be_an_instance_of List
  end

  it 'tells you its name' do
    test_list = List.new({:name=>'Home'})
    expect(test_list.name).to eq 'Home'
  end

  it 'starts with an empty array' do
    expect(List.all).to eq []
  end

  it 'saves a new list in an array' do
    test_list = List.new({:name=>'Home'})
    test_list.save
    expect(List.all).to eq [test_list]
  end

  it 'has two lists equal to each other if names match' do
    test_list1 = List.new({:name=>'Home'})
    test_list2 = List.new({:name=>'Home'})
    expect(test_list1).to eq test_list2
  end


end

require "pg"
require "./lib/task.rb"
require "./lib/list.rb"

DB = PG.connect(:dbname => "to_do_list")
@current_list = nil
@current_task = nil

def main_menu

  puts "\n"
  puts "*" * 60
  puts "Welcome to the To Do List Ruby/PostgreSQL application"
  puts "*" * 60
  puts "\n"

  input_option = ""
  while input_option != "x" do

    puts "Main options:"
    puts "  m = main_menu"
    puts "  x = exit"
    puts "List options:"
    puts " la = add a list"
    puts " ll = list all lists"
    puts " lc = choose a specific list"
    puts " ld = delete a list (also deletes all tasks in the list)"
    puts "Task options:"
    puts " ta = add a task to the current list"
    puts " tl = list all tasks in the current list"
    puts " tc = choose a specific task from the current list"
    puts " td = delete a task"
    puts "\n"
    puts "Please enter what option you would like to perform"

    input_option = gets.chomp.downcase
    if input_option == "x"
      exit
    elsif input_option == "m"
      main_menu
    elsif input_option == "la"
      add_list
    elsif input_option == "ll"
      list_lists
    elsif input_option == "lc"
      choose_list
    elsif input_option == "ld"
      delete_list
    elsif input_option == "ta"
      add_task
    elsif input_option == "tl"
      list_tasks
    elsif input_option == "tc"
      choose_task
    elsif input_option == "td"
      delete_task
    else
      puts "\nIncorrect option chosen, please try again\n"
      main_menu
    end
  end
end

def add_list
  puts "\nPlease enter a list name"
  response = gets.chomp
  new_list = List.new({:name=>response})
  new_list.save
  puts "\nCreated list #{response}\n\n"
end

def list_lists
  results = List.all
  if results.length > 0
    puts "\nHere are all of the lists in the database"
    results.each_with_index do |result, index|
      puts "#{(index+1).to_s}. #{result.name}"
    end
    puts "\n"
  else
    puts "\nThere are no lists to show\n\n"
  end
end

def choose_list
  list_lists
  if List.all.length > 0
    puts "\nWhich list would you like to select?"
    selected_list = gets.chomp.to_i
    if selected_list <= 0 || selected_list > List.all.length
      puts "Incorrect index input, please try again"
      choose_list
    else
      @current_list = List.all[selected_list-1]
      puts "\nYou have selected list #{selected_list}\n\n"
    end
  end
end

def delete_list
  choose_list
  if List.all.length > 0
    @current_list.delete
    puts "\nDeleted list #{@current_list.name}\n\n"
  end
end

def add_task
  choose_list
  if List.all.length > 0
    puts "\nPlease enter a task name"
    response = gets.chomp
    new_task = Task.new({:name=>response, :list_id=>@current_list.id})
    new_task.save
    puts "\nCreated task #{response}\n\n"
  end
end

def list_tasks
  choose_list
  if List.all.length > 0
    results = Task.choice(@current_list)
    if results.length > 0
      puts "Here are all the tasks for #{@current_list.name}"
        results.each_with_index do |result, index|
        puts "#{(index+1).to_s}. #{result.name}"
      end
      puts "\n"
    else
      puts "\nThere are no tasks to show\n\n"
    end
  end
end

def choose_task
  list_tasks
  if Task.choice(@current_list).length > 0
    puts "\nWhich task would you like to select?"
    selected_task = gets.chomp.to_i
    if selected_task <= 0 || selected_task > Task.choice(@current_list).length
      puts "Incorrect index input, please try again"
      choose_task
    else
      @current_task = Task.choice(@current_list)[selected_task-1]
      puts "\nYou have selected task #{@current_task.name} of list #{@current_list.name}\n\n"
    end
  end
end

def delete_task
  choose_task
  if Task.choice(@current_list).length > 0
    @current_task.delete
    puts "\nDeleted task #{@current_task.name} of list #{@current_list.name}\n\n"
  end
end

main_menu

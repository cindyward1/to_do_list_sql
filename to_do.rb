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

    puts "\nMain options:"
    puts "  m = main_menu"
    puts "  x = exit"
    puts "List options:"
    puts " la = add a list"
    puts " ll = list all lists"
    puts " lc = choose a specific list"
    puts " ld = delete a list (also deletes all tasks in the list)"
    puts "Task options:"
    puts " tm = list completed tasks in all lists"
    puts " ta = add a task to the current list"
    puts " tl = list all tasks in the current list"
    puts " ts = list all tasks in the current list sorted by due date"
    puts " tc = choose a specific task from the current list (optionally mark as completed)"
    puts " td = delete a task"
    puts " te = edit a task's completion status, name, and/or due date"
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
    elsif input_option == "ts"
      list_tasks_sorted
    elsif input_option == "tc"
      choose_task
    elsif input_option == "td"
      delete_task
    elsif input_option == "tm"
      show_completed_tasks
    elsif input_option == "te"
      edit_task
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

def show_completed_tasks
  results_list = List.all
  if results_list.length > 0
    results_list.each do |list|
      results_task = Task.choice(list)
      if results_task.length > 0
        count_completed = 0
        results_task.each do |task|
          if task.completed?
            if count_completed == 0
              puts "\nThe completed tasks for list #{list.name} are" # print list header only if completed tasks
            end
            puts "- #{task.name}"
          end
        end
      end
    end
  else
    puts "\nThere are no lists to show"
  end
  puts "\n\n"
end

def add_task
  choose_list
  if List.all.length > 0
    puts "\nPlease enter a task name"
    response_name = gets.chomp
    puts "\nPlease enter a due date for this task (format MM/DD/YYYY)"
    new_due_date = gets.chomp
    if new_due_date !~ /\d\d\/\d\d\/\d\d\d\d/
      puts "\nInvalid format for due date, please try again\n"
      add_task
    else
      due_date = new_due_date
      new_task = Task.new({:name=>response_name, :list_id=>@current_list.id, :completed=>false,
                           :due_date=>new_due_date})
      new_task.save
      puts "\nCreated task #{response_name}\n\n"
    end
  end
end

def list_tasks
  choose_list
  if List.all.length > 0
    results = Task.choice(@current_list)
    if results.length > 0
      puts "\nHere are all the tasks for #{@current_list.name}\n"
        results.each_with_index do |result, index|
          if result.completed?
            completed_string = "is complete"
          else
            completed_string = "is not complete"
          end
          puts "#{(index+1).to_s}. #{result.name} is due on #{result.due_date} and #{completed_string}"
        end
      puts "\n"
    else
      puts "\nThere are no tasks to show\n\n"
    end
  end
end

def list_tasks_sorted
  choose_list
  if List.all.length > 0
    puts "\nWould you like the task list sorted with the earliest due first or the latest due first?"
    puts "Please enter either 'earliest' or 'latest'"
    sort_order = gets.chomp.downcase
    if sort_order == "earliest" || sort_order == "latest"
      if sort_order == "earliest"
        sort_order_SQL = "ASC"
      elsif sort_order == "latest"
       sort_order_SQL = "DESC"
      end
      results = Task.choice_sorted(@current_list, sort_order_SQL)
      if results.length > 0
        puts "\nHere are all the tasks for #{@current_list.name} with #{sort_order} due first\n"
        results.each_with_index do |result, index|
          if result.completed?
            completed_string = "is complete"
          else
            completed_string = "is not complete"
          end
          puts "#{(index+1).to_s}. #{result.name} is due on #{result.due_date} and #{completed_string}"
        end
      puts "\n"
      else
       puts "\nThere are no tasks to show\n\n"
      end
    else
      puts "\nInvalid sort order chosen\n\n"
    end
  end
end

def choose_task
  list_tasks
  if Task.choice(@current_list).length > 0
    puts "Which task would you like to select?"
    selected_task = gets.chomp.to_i
    if selected_task <= 0 || selected_task > Task.choice(@current_list).length
      puts "Incorrect index input, please try again"
      choose_task
    else
      @current_task = Task.choice(@current_list)[selected_task-1]
      puts "\nYou have selected task #{@current_task.name} of list #{@current_list.name}"
      puts "Would you like to mark this task as completed? (y or yes = yes, anything else = no)"
      answer = gets.chomp.downcase
      if answer == "y" || answer == "yes"
        @current_task.completed = true
        @current_task.mark_complete
        puts "Task #{@current_task.name} has been marked as completed"
      end
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

def edit_task
  choose_task
  if Task.choice(@current_list).length > 0
    puts "\nWould you like to edit the task name? (y or yes = yes, anything else = no)"
    answer_name = gets.chomp.downcase
    if answer_name == "y" || answer_name == "yes"
      puts "\nWhat is the new task name?"
      new_task_name = gets.chomp
      @current_task.update_name(new_task_name)
      puts "\nTask name has been changed to #{@current_task.name}\n"
    end
    puts "\nWould you like to edit the due date name? (y or yes = yes, anything else = no)"
    answer_name = gets.chomp.downcase
    if answer_name == "y" || answer_name == "yes"
      puts "\nPlease enter a new due date"
      new_due_date = gets.chomp
      if new_due_date !~ /\d\d\/\d\d\/\d\d\d\d/
       puts "\nInvalid format for due date, please try again\n"
       edit_task
      else
       @current_task.update_due_date(new_due_date)
       puts "\nTask due date has been changed to #{@current_task.due_date}\n\n"
      end
    end
  end
end

main_menu

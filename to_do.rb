require "pg"
require "./lib/task.rb"
require "./lib/list.rb"

DB = PG.connect(:dbname => "to_do_list")
@current_list = nil

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
  puts "\nPlease enter a name for your list:"
  response = gets.chomp
  new_list = List.new({:name=>response})
  new_list.save
  puts "\nCreated list #{response}\n\n"
end

def list_lists
  puts "\nHere are all of the lists in the database"
  results = List.all
  results.each_with_index do |result, index|
    puts "#{(index+1).to_s}. #{result.name}"
  end
  puts "\n"
end

main_menu

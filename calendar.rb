require 'active_record'
require 'pry'
require './lib/event'
require './lib/todo'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])

def welcome
  puts `clear`
  puts "Event Manager 5000"
  main
end

def main
  print `clear`
  input = nil
  until input == 'x'
    puts "\n[C]reate new event, [V]iew events, [N]ew todo, [L]ist todos, E[x]it\n"
    input = gets.chomp.downcase
    case input
    when 'c'
      create_event
    when 'v'
      view_menu
    when 'n'
      create_todo
    when 'l'
      view_todo      
    when 'x'
      puts "\nGood-bye!\n"
      exit
    else
      puts "\nI'm sorry, but I didn't understand that.\n"
    end
  end
end

def create_event
  print `clear`
  puts "\nCreate an Event\n\n"
  print "Enter a description: "
  description = gets.chomp
  print "Location: "
  location = gets.chomp
  print "Start day and time (YYYY-MM-DD HH:MM): "
  start_timestamp = gets.chomp
  print "End day and time (YYYY-MM-DD HH:MM): "
  end_timestamp = gets.chomp
  new_event = Event.new(description: description, location: location, start_timestamp: start_timestamp, end_timestamp: end_timestamp)
  if new_event.save
    puts "Created!"
  else
    puts "I'm sorry, something went wrong. Please try again."
    create_event
  end
end

def view_menu
  puts "\n[A]ll, [T]oday, [U]pcoming, [B]etween dates, [M]ain menu.\n"
  input = gets.chomp
  case input.downcase
  when 'a'
    view_all
  when 't'
    view_today
  when 'u'
    view_upcoming
  when 'b'
    view_between
  when 'm'
    main
  else
    puts "I'm sorry, that is not a valid option."
    view_menu
  end
end

def print_events(events)
  events.each_with_index do |event, index|
    puts "#{index + 1}. #{event.description}"
    puts "   Where: #{event.location}" if event.location
    puts "   Start: #{event.start_timestamp.strftime('%^a, %^b %e, %Y @ %l:%M%P')}" if event.start_timestamp
    puts "     End: #{event.end_timestamp.strftime('%^a, %^b %e, %Y @ %l:%M%P')}\n\n" if event.end_timestamp
  end
  select_event(events)
end

def view_all
  puts "\nView Events\n\n"
  events = Event.order('start_timestamp')
  print_events(events)
end

def view_today
  puts "\nToday's Events\n\n"
  events = Event.today
  print_events(events)  
end

def view_upcoming
  puts "\nUpcoming Events\n\n"
  events = Event.upcoming
  print_events(events)
end

def view_between
  puts "\nView Events Between Dates\n\n"
  print "Start date (YYYY-MM-DD): "
  start_date = gets.chomp
  print "End date (YYYY-MM-DD): "
  end_date = gets.chomp
  puts
  events = Event.between(start_date, end_date)
  print_events(events)
end

def select_event(events)
  puts "Enter event number to edit or [M]enu to go back."
  user_choice = gets.chomp
  if user_choice == 'm'
    main
  elsif user_choice.to_i > 0
    edit_event(events[user_choice.to_i - 1])
  else
    puts "\n\nI'm sorry, that is not a valid option.\n\n"
    select_event(events)
  end
end

def edit_event(event)
  puts "\nEdit Event\n\n"
  puts " #{event.description}"
  puts " Where: #{event.location}" if event.location
  puts " Start: #{event.start_timestamp.strftime('%^a, %^b %e, %Y @ %I:%M%P')}" if event.start_timestamp
  puts "   End: #{event.end_timestamp.strftime('%^a, %^b %e, %Y @ %I:%M%P')}" if event.end_timestamp
  puts " Notes: #{event.notes}\n\n"
  puts "Edit [D]escription, [L]ocation, [S]tart date, [E]nd date, [N]otes, [R]emove."
  puts "[M]ain menu."
  user_choice = gets.chomp.downcase
  case user_choice
  when 'd'
    print "Enter new description: "
    event.update(description: gets.chomp)
  when 'l'
    print "Enter new location: "
    event.update(location: gets.chomp)
  when 's'
    print "Enter new start date and time (YYYY-MM-DD HH:MM): "
    event.update(start_timestamp: gets.chomp)
  when 'e'
    print "Enter new end date and time (YYYY-MM-DD HH:MM): "
    event.update(end_timestamp: gets.chomp)
  when 'n'
    print "Enter new note: "
    event.update(notes: gets.chomp)
  when 'r'
    print "Are you sure you want to remove this event from the database? (y/n): "
    if gets.chomp.downcase == 'y'
      event.destroy
      puts "\nEvent removed!\n\n"
      main
    else
      puts "\nOkay, event not removed.\n\n"
    end
  when 'm'
    main
  else
    puts "I'm sorry, that is not a valid option."
    edit_event(event)
  end
  puts "\nEvent updated."
  edit_event(event)
end

def view_todo
  puts "\nTodo\n\n"
  todos = Todo.order('complete').reverse_order
  todos.each_with_index do |todo, index|
    puts "#{index + 1}. #{todo.complete ? '[X]' : '[ ]'} #{todo.description}"
  end
  todo_menu(todos)
end

def create_todo
  print "Enter a description: "
  Todo.create(description: gets.chomp)
  view_todo
end

def todo_menu(todos)
  puts "\nEnter the todo number to view more details or [M]ain menu."
  input = gets.chomp
  if input.to_i > 0
    todo_details(todos[input.to_i - 1])
  elsif input.downcase == 'm'
    main
  else
    puts "Sorry, that doesn't work."
  end
end

def todo_details(todo)
  puts "  #{todo.complete ? '[X]' : '[ ]'} #{todo.description}"
  puts "\n[M]ark as done, [E]dit description, [D]elete, Back to [T]odos."
  input = gets.chomp.downcase
  case input
  when 'm'
    todo.update(complete: true)
    puts "Well done!"
    view_todo
  when 'e'
    print "\nEnter new description: "
    todo.update(description: gets.chomp)
    todo_details(todo)
  when 'd'
    todo.destroy
    puts "Deleted!\n\n"
  when 't'
    view_todo
  else
    puts "Umm..."
    todo_details
  end
end

welcome

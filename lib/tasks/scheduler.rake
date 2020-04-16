desc "This task is called by the Heroku scheduler add-on"
task :reset_todos => :environment do
  puts "Reseting todos..."
  Todo.reset_unfinished
  puts "done."
end

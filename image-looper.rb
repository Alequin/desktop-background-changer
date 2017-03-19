require_relative "BackgroundImageLooper"

looper = BackgroundImageLooper.new

loop{
  puts "Select an option \n" +
  "(1) Start \n" +
  "(2) Change image source file \n\n" +
  "(9) Exit"

  case UserInput.get_single_digit_input
  when 1
    looper.start_loop
  when 2
    puts
    looper.get_new_file_location
  when 9
    exit
  else
    puts "Invalid input\n\n"
  end
  puts
}

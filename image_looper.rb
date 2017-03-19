
looper = BackgroundImageLooper.new

puts "Select an option \n" +
"(1) Start \n" +
"(2) Change image source file \n"

case UserInput.get_single_digit_input
when 1
  looper.start_loop
when 2
  looper.get_new_file_location
end

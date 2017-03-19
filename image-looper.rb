require_relative "BackgroundImageLooper"

$LOOPER = BackgroundImageLooper.new("/home/alequin/Pictures/Wallpapers/")

def print_image_names
  $LOOPER.get_image_names.each_with_index{ |image,index|
      puts "#{index+1}: #{image}"
  }
end

loop{
  puts "Select an option \n" +
  "(1) Start \n" +
  "(2) Change image source file \n" +
  "(3) Print directory in use\n" +
  "(4) Print images names\n" +
  "\n" +
  "(9) Exit"

  user_selection = UserInput.get_single_digit_input
  puts
  case user_selection
  when 1
    $LOOPER.start_loop
  when 2
    $LOOPER.get_new_file_location
  when 3
    puts $LOOPER.current_path
  when 4
    print_image_names
  when 9
    exit
  else
    puts "Invalid input\n\n"
  end
  puts
}

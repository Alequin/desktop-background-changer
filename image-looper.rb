require_relative "BackgroundImageLooper"

$LOOPER = BackgroundImageLooper.new("/home/alequin/Pictures/Wallpapers/")

def print_image_names
  $LOOPER.get_image_names.each_with_index{ |image,index|
      puts "#{index+1}: #{image}"
  }
end

def run_image_removal
  puts "Enter the numbers of the images you want to remove. Enter 0 when you are done"
  loop{
    image_count = $LOOPER.get_image_count
    if(image_count == 1)
      puts "Only one image remaining. Returning to menu"
      return
    end
    print "Image: "
    user_input = UserInput.get_int_input
    if(user_input < 0)
      puts "Value should be positive"
    end
    if(user_input > image_count)
      puts "Value entered is to high"
    end
    break if user_input == 0
    $LOOPER.remove_from_images(user_input-1)
    print_image_names

  }
end

loop{
  puts "Select an option \n" +
  "(1) Start \n" +
  "(2) Change image source file \n" +
  "(3) Print directory in use\n" +
  "(4) Print images names\n" +
  "(5) Remove images from current list\n" +
  "(6) Re-load images from file\n" +
  "\n" +
  "(9) Exit"

  user_selection = UserInput.get_single_digit_input
  puts
  case user_selection
  when 1
    puts "Loop starting"
    $LOOPER.start_loop
  when 2
    $LOOPER.get_new_file_location
  when 3
    puts $LOOPER.current_path
  when 4
    print_image_names
  when 5
    print_image_names
    puts
    run_image_removal
  when 6
    $LOOPER.reload_images
  when 9
    exit
  else
    puts "Invalid input\n\n"
  end
  puts
}

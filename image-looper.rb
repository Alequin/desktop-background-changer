require_relative "BackgroundImageLooper"

$DATA_FILE_PATH = "data.txt"
$LOOPER = BackgroundImageLooper.new

def write_to_data_file
  File.open($DATA_FILE_PATH, "w") { |file|
    file.write("#{$LOOPER.current_path}\n")
    file.write("#{$LOOPER.image_switch_timer}\n")
    file.write("#{$LOOPER.image_selection_random}\n")
  }
end

def print_image_names
  $LOOPER.get_image_names.each_with_index{ |image,index|
      puts "#{index+1}: #{image}"
  }
end

def ask_user_for_new_image_switch_timer
  puts "Current timer: #{$LOOPER.image_switch_timer / 60} minutes"
  print "New time in minutes: "
  new_time = nil
  loop{
    new_time = UserInput.get_int_input*60
    if(new_time <=0)
      print "Value must be greater than zero: "
    else
      break
    end
  }
  $LOOPER.image_switch_timer = new_time
end

def ask_user_for_new_file_path

    puts "Please input a valid file location\n Example: /home/user/Pictures/\n"
    print "Your file location: "

    file_path = gets.chomp

    if (!File.exist?(file_path))
      puts "Sorry the file location does not exist"
      return false
    end

    if(!$LOOPER.set_new_file_location(file_path))
      puts "Sorry the requested file location does not hold any valid images: #{$LOOPER.get_valid_formats_as_string}"
      return false
    end
    return true
end


def ask_user_to_remove_images
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

data = nil
if(File.exist?($DATA_FILE_PATH))
  data = File.readlines($DATA_FILE_PATH)
end

if(data == nil || data.size == 0)
  loop{
    break if ask_user_for_new_file_path
  }
  write_to_data_file
else
  $LOOPER.set_new_file_location(data[0].sub("\n",""))
  $LOOPER.image_switch_timer = data[1].sub("\n","").to_i
  $LOOPER.image_selection_random = data[2].sub("\n","") == "true"
end

$LOOPER.load_current_file_images

loop{
  puts "Select an option \n" +
  "(1) Start \n" +
  "(2) Change image source file \n" +
  "(3) Change image switch timer \n" +
  "(4) Print directory in use\n" +
  "(5) Print images names\n" +
  "(6) Remove images from current list\n" +
  "(7) Re-load images from file\n" +
  "(8) Toggle image randomisation\n" +
  "\n" +
  "(0) Exit"

  user_selection = UserInput.get_single_digit_input
  puts
  case user_selection
  when 1
    puts "Loop starting"
    $LOOPER.start_loop
  when 2
    ask_user_for_new_file_path
    write_to_data_file
  when 3
    ask_user_for_new_image_switch_timer
    write_to_data_file
  when 4
    puts $LOOPER.current_path
  when 5
    print_image_names
  when 6
    print_image_names
    puts
    ask_user_to_remove_images
  when 7
    $LOOPER.load_current_file_images
  when 8
    $LOOPER.image_selection_random = !$LOOPER.image_selection_random
    print "Image selection "
    if($LOOPER.image_selection_random)
      puts "random"
    else
      puts "linear"
    end
    write_to_data_file
  when 0
    exit
  else
    puts "Invalid input\n\n"
  end
  puts
}

require_relative "user_input"

class BackgroundImageLooper

  #The console command used by Gnome 3 to set the background image
  @@SET_BACKGROUND_COMMAND = 'gsettings set org.gnome.desktop.background picture-uri "file://'

  def initialize
    default_image_path = "/home/alequin/Pictures/Wallpapers/"
    puts "Loading images from #{default_image_path} \n\n"
    @images = load_images(default_image_path)
    @image_switch_timer = 5
  end

  def start_loop
    puts "Loop starting"
    image_to_use = nil
    loop{
      image_to_use = get_next_image(image_to_use)
      set_background_image(image_to_use)
      puts "Image changed to #{image_to_use.scan(/\w+\.\w+/)}"
      sleep @image_switch_timer
    }
  end

  def get_new_file_location
    puts "Please input a valid file location\n Example: /home/alequin/Pictures/\n"
    print "Your file locaton:"
    new_files = load_images(gets.chomp)
  end

  private

  def load_images(path_to_images)
    #grab all image files (full path included)
    return Dir["#{path_to_images}*"]
  end

  def set_background_image(image_path)
    #run system command to set background image
    system(@@SET_BACKGROUND_COMMAND + image_path + '"')
  end

  def get_next_image(previous_image)
    loop{
      new_image = @images[rand(@images.length)]
      #check image new_image is not equal to previous image
      if(new_image != previous_image)
        return new_image
      end
    }
  end

end

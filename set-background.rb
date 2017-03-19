require_relative "user_input"

class BackgroundImageLooper

  @@SET_BACKGROUND_COMMAND = 'gsettings set org.gnome.desktop.background picture-uri "file://'

  def initialize
    default_image_path = "/home/alequin/Pictures/Wallpapers/"
    puts "Loading images from #{default_image_path} \n\n"
    @images = load_images(default_image_path)
    @image_switch_timer = 5
  end

  def show_menu
    puts "Select an option \n" +
    "(1) Start \n" +
    "(2) Change image source file \n"

    case UserInput.get_single_digit_input
    when 1
      start_loop
    when 2
    end

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
      if(new_image != previous_image)
        return new_image
      end
    }


  end

end

BackgroundImageLooper.new.show_menu

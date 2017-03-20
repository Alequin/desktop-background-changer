require_relative "user_input"
require "pathname"

class BackgroundImageLooper

  attr_accessor :current_path, :image_switch_timer, :image_selection_random

  #The console command used by Gnome 3 to set the background image
  @@SET_BACKGROUND_COMMAND = 'gsettings set org.gnome.desktop.background picture-uri "file://'
  @@VALID_FORMATS = [".jpg", ".png"]

  def initialize
    @image_switch_timer = 3600
    @image_selection_random = true
  end

  def start_loop
    image_to_use = nil
    last_used_index = 0
    loop{
      if(@image_selection_random)
        image_to_use = get_random_image(image_to_use)
      else
        image_to_use = @images[last_used_index]
        last_used_index += 1
        if(last_used_index >= @images.length)
          last_used_index = 0
        end
      end
      set_background_image(image_to_use)
      sleep @image_switch_timer
    }
  end

  def set_new_file_location(new_path)

    if(!File.exist?(new_path))
      raise IOError, "File does not exist"
    end

    if(!new_files = load_images(new_path))
      return false
    end

    #If no issues raised set @images to new_files
    @images = new_files
    return true
  end

  def get_image_names
    image_names = Array.new
    @images.each_with_index{ |image, index|
      image_names.push(image.scan(/[\w+,_,\s,-]+\.\w+$/)[0])
    }
    return image_names
  end

  def get_image_count
    return @images.length
  end

  #Remove one or more images from the @images array
  def remove_from_images(to_remove)
      @images.delete_at(to_remove)
  end

  #reload the images from the current path
  def load_current_file_images
    @images = load_images(@current_path)
  end

  def get_valid_formats_as_string
    return "#{@@VALID_FORMATS.join(", ")}"
  end

  private

  def load_images(path_to_images)
    #grab all image files (full path included)
    puts "Loading images from #{@current_path} \n\n"
    loaded_images = remove_non_image_files(Dir["#{path_to_images}*"])
    if(loaded_images.length == 0)
      return false
    end
    @current_path = path_to_images
    return loaded_images
  end

  def set_background_image(image_path)
    #run system command to set background image
    system(@@SET_BACKGROUND_COMMAND + image_path + '"')
    system('date "+%H:%M:%S"')
    puts "Image changed to #{image_path.scan(/[\w+,_,\s,-]+\.\w+$/)[0]}"
  end

  def get_random_image(previous_image)
    loop{
      new_image = @images[rand(@images.length)]
      #check image new_image is not equal to previous image
      if(new_image != previous_image)
        return new_image
      end
    }
  end

  #removes all file paths from the given array that are not defined by
  #@@VALID_FORMATS and returns a new array
  def remove_non_image_files(files)

    valid_images = Array.new
    files.each{ |image_path|
      current_image_format = image_path.scan(/\.\w+/)[0]
      @@VALID_FORMATS.each{ |valid_image_format|
        if(valid_image_format == current_image_format)
          valid_images.push(image_path)
          break;
        end
      }
    }
    return valid_images
  end

  #checks if path exists. Returns false and informs the user if it does not
  def path_exists?(path)
    if(!Pathname.new(path).exist?)
      puts "Sorry the file path does not exist. Please check the entered path\n" +
      "Entered path: #{path}"
      sleep 2
      return false
    end
    return true;
  end

end

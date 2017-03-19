require_relative "user_input"
require "pathname"

class BackgroundImageLooper

  attr_reader :current_path

  #The console command used by Gnome 3 to set the background image
  @@SET_BACKGROUND_COMMAND = 'gsettings set org.gnome.desktop.background picture-uri "file://'
  @@VALID_FORMATS = [".jpg", ".png"]

  def initialize(inital_path)
    @current_path = inital_path
    puts "Loading images from #{@current_path} \n\n"
    @images = load_images(@current_path)
    @image_switch_timer = 5
  end

  def start_loop
    puts "Loop starting"
    image_to_use = nil
    loop{
      image_to_use = get_next_image(image_to_use)
      set_background_image(image_to_use)
      puts "Image changed to #{image_to_use.scan(/\w+\.\w+/)[0]}"
      sleep @image_switch_timer
    }
  end

  def get_new_file_location
    puts "Please input a valid file location\n Example: /home/alequin/Pictures/\n"
    print "Your file location: "
    file_path = Pathname.new(gets.chomp)
    if(!file_path.exist?)
      puts "Sorry the file path does not exist. Please check the entered path\n" +
      "Entered path: #{file_path.to_s}"
      sleep 2
      return
    end
    new_files = load_images(file_path.to_s)

    if(new_files.length == 0)
      puts "Sorry the specified location contains no usable files please use another " +
      "path or provide this path with files of a valid format: #{@@VALID_FORMATS.join(", ")}"
      sleep 2
      return
    end
    #If no issues raised set @images to new_files
    @current_path = file_path.to_s
    @images = new_files
  end

  def get_image_names
    image_names = Array.new
    @images.each_with_index{ |image, index|
      image_names.push(image.scan(/\w+\.\w+/)[0])
    }
    return image_names
  end

  private

  def load_images(path_to_images)
    #grab all image files (full path included)
    return remove_non_image_files(Dir["#{path_to_images}*"])
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

  #removes all file paths from the given array that are not jpg or png
  #and returns a new array
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

end

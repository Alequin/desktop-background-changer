module UserInput

  def self.get_single_digit_input()

    loop{
      selected_position = gets.chomp
      if(selected_position.size == 1 && selected_position.scan(/[1-9]/).size != 0)
        return selected_position.to_i
      end
      puts "Sorry the value has to be a single number with one digit"
      print "Try again: "
    }
  end

end

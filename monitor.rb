require './commands'

class Monitor
  def initialize
    @last_diff = ''
    if Commands::status.include? "Not a git repository" then
      puts 'Not a git repository!'
      return 0
    end
    menu
  end

  def check_changed
    Commands::status.include? "nothing to commit"
  end

  def monitor_change
    while check_changed
      sleep 1
    end
  end

  def check_changes
    if !(@last_diff == get_changes)
      show_changes
      @last_diff = get_changes
      true
    else
      @last_diff = get_changes
      false
    end
  end

  def run
    monitor = Thread.new do
      while true
        monitor_change
        check_changes
        sleep 1
      end
    end
    sleep 1

    running = true
    while running
      print 'Choose:'
      input = gets.chomp
      if input.size > 0
        case input[0].upcase
        when '1' then Commands::diff(input[1..input.length])
        when '2' then Commands::add(input[1])
        when '3' then Commands::commit(input[1], input[2..10])
        when '0','Q' then running = false
        when 'H' then menu
        else puts 'error'; menu
        end
        show_changes
      end
    end
  end
end

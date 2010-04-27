class Monitor

  @last_diff

  def initialize
    @last_diff = ''
    if status.include? "Not a git repository" then
      puts 'Not a git repository!'
      return 0
    end
    menu
  end

  def menu
    puts 'git monitor menu :-'
    puts '0/q - Quit'
    puts '1/d - diff'
    puts '2/a - add'
    puts '3/c - commit'
  end

  def status
    `git st`
  end

  def get_changes
    `git diff --stat`
  end
  def show_changes
    system 'git diff --stat'
  end


  def check_changed
    status.include? "nothing to commit"
  end

  def monitor_change
    while check_changed
      sleep 1
    end
  end

  def check_changes
    if !(@last_diff == get_changes)
      puts
      puts '---'
      puts show_changes #get_changes
      puts '---'
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
#      print 'Choose:'
      input = gets.chomp
      if input.size > 0
        case input[0].upcase
        when '1' then run_diff(input[1])
          when '2' then run_add(input[1])
          when '3' then run_commit(input[1], input[2..10])
          when '0','Q' then running = false
          else puts 'error'; menu
        end
      end
    end
  end

  def run_diff(file_number)
    puts "diff #{file_number}"
    if file_number
      system 'git diff'
    else
      system 'git diff'
    end
  end

  def run_add(file_num)
    puts 'add'
#    puts message
#    system "git add -m #{message}"
    system "git add ."
  end

  def run_commit(file_num, text)
    message = text
    if !message
      print 'enter commit message:'
      message = gets.chomp
    end
#    puts "commit #{text}"
    command = "git commit -m \"#{message}\""
    puts command
    system command
  end

end

Monitor.new.run


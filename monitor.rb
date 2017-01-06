class Git
  class << self
    def status(short = false)
      short ? `git status -s` : `git status`
    end

    def get_changes
      `git diff --stat`
    end

    def name_only
      `git diff --name-only`
    end

    def is_a_git_repo?
      !status.include? "Not a git repository"
    end

    def changed?
      status.include? "nothing to commit"
    end
  end
end

class Commands
end

class Monitor
  def initialize
    @last_diff = ''
    if !Git.is_a_git_repo?
      puts 'Not a git repository!'
      return 0
    end
    menu
  end

  def menu
    puts 'git monitor menu :-'
    puts '0/q - Quit'
    puts 'h   - Help'
    puts '1/d - diff'
    puts '2/a - add'
    puts '3/c - commit'
  end

  def show_changes
    if Git.get_changes.size > 0
      puts "--- #{Time.now} ---"
      #Git.get_changes
      system 'git --no-pager diff --stat'
      puts '---'
    end
  end

  def monitor_change
    while Git.changed?
      sleep 1
    end
  end

  def check_changes
    if !(@last_diff == Git.get_changes)
      show_changes
    end
    @last_diff = Git.get_changes
  end

  def run
    monitor = Thread.new do
      while true
        #monitor_change
        check_changes
        sleep 1
      end
    end

    running = true
    while running
      input = gets.chomp
      if input.size > 0
        case input[0].upcase
        when '1','D' then run_diff(input[1..input.length])
        when '2','A' then run_add(input[1])
        when '3','C' then run_commit(input[1], input[2..10])
        when '0','Q' then running = false
        when 'H' then menu
        else puts 'error'; menu
        end
        show_changes
      end
    end
  end

  # allow filename or number in list
  def run_diff(file_name_number)
    puts "diff #{file_name_number}"
     #    if file_name_number.to_i.istypeofint
    if file_name_number
      system "git diff #{file_name_number}"
    else
      system 'git diff'
    end
  end

  def run_add(file_num)
    puts 'add'
    system "git add ."
  end

  def run_commit(file_num, text)
    message = text
    if !message
      print 'enter commit message:'
      message = gets.chomp
    end
    command = "git commit -m \"#{message}\""
    puts command
    system command
    puts '---'
  end
end

Monitor.new.run

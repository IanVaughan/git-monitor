class Git

end

class Monitor

  @last_diff

  def initialize
    @last_diff = ''
    if status.include? "Not a git repository" then
      puts 'Not a git repository!'
      return 0
    end

  end

  def status
    `git st`
  end

  def get_changes
    `git diff --stat`
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
      puts '---'
      puts get_changes
      puts '---'
      puts 'Watching...'
      @last_diff = get_changes
      true
  else
      @last_diff = get_changes
      false
    end
  end

  def run
    while true
      monitor_change
      if check_changes
        Thread.new {
          puts 'test'

          }
      else
        sleep 1
      end
    end
  end

end

puts 'Watching...'
Monitor.new.run


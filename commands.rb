module Commands
  extend self

  def status
    `git status`
  end

  def status_short
    `git status -s`
  end

  def get_changes
    `git diff --stat`
  end

  def show_changes
    if get_changes.size > 0 then
      puts "--- #{Time.now} ---"
      system 'git diff --stat'
    end
  end

  def name_only
    `git --no-pager diff --name-only`
  end

  # allow filename or number in list
  def diff(file_name_number)
    puts "diff #{file_name_number}"
    command = "git diff"
    command += " #{file_name_number}" if file_name_number #.to_i.istypeofint
    system command
  end

  def add(file_num)
    system "git add ."
  end

  def commit(file_num, text)
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

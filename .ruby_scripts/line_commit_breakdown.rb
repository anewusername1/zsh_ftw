class Breakdown
  def self.gather_stats(directory = '.')
    users = {}
    files_scanned = []
    all_files = gather_files(directory)
    files = all_files.each do |file|
      next if(File.extname(file) != '.rb')
      begin
        blamed = `git blame #{file}`
        split_blame = blamed.split("\n")
        split_blame.each do |line|
          name = line.scan(/\(([\w\s]+) [\d]+-/).flatten[0].strip
          users[name].nil? ? users[name] = 1 : users[name] += 1
        end
        files_scanned << file
      rescue
        next
      end
    end
    Hash[*users.sort_by {|key,value| value}.reverse.flatten]
  end

  def self.gather_files(start_dir)
    files = []
    Dir["#{start_dir}/*"].each do |file|
      if(File.directory?(file))
        files += gather_files(file)
      else
        files << file
      end
    end
    files
  end

  def self.is_git_repo?(dir)
    `cd #{dir} && git status` =~ /\# On branch/
  end
end

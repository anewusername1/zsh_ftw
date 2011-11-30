require 'rake'

def move_files(file_extension = '.symlink')
  linkables = Dir.glob("*/**{#{file_extension}}")

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split('/').last.split("#{file_extension}").last
    target = "#{ENV["HOME"]}/.#{file}"

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{linkable}" "#{target}"`
  end
end

def unmove_files(file_extension = '.symlink')
  Dir.glob('**/*#{file_extension}').each do |linkable|

    file = linkable.split('/').last.split("#{file_extension}").last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end
end

def link_vim_plugins
  FileUtils.mkdir_p("#{ENV['HOME']}/.vim/plugin") if(!File.exists?("#{ENV['HOME']}/.vim/plugin"))
  `find $PWD/vim/plugin -name "*.vim"`.split("\n").each do |file|
    `ln -sf #{file} #{ENV['HOME']}/.vim/plugin`
  end
end

desc "Hook our dotfiles into system-standard positions."
namespace :install do
  task :vim do
    move_files('.vimlink')
    `./tools/vimbundles`
    link_vim_plugins
  end

  task :update_vimbundles do
    `./tools/vimbundles`
  end

  task :dotfiles do
    move_files
  end
end

namespace :uninstall do
  task :vim do
    unmove_files('.vimlink')
  end

  task :dotfiles do
    unmove_files
  end
end

task :install => ['install:dotfiles']
task :default => 'install'

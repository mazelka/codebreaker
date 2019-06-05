module IOHelper
  def show_welcome
    open_file(File.expand_path('..', __dir__) + '/storage/welcome_message.txt')
  end

  def show_help
    open_file(File.expand_path('..', __dir__) + '/storage/help.txt')
  end

  def show_rules
    open_file(File.expand_path('..', __dir__) + '/storage/rules.txt')
  end

  def show_hints_help
    open_file(File.expand_path('..', __dir__) + '/storage/hints_help.txt')
  end

  def open_file(path)
    File.open(path) do |f|
      f.each_line do |line|
        puts line
      end
    end
  end
end

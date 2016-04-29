module TerminalWidthCalculator
  def self.calculate
    default_width = 80

    term_width = calculate_term_width

    term_width > 0 ? term_width : default_width
  end

  private

  def self.calculate_term_width
    if ENV['COLUMNS'] =~ /^\d+$/
      ENV['COLUMNS'].to_i
    elsif tput_case?
      `tput cols`.to_i
    elsif stty_case?
      `stty size`.scan(/\d+/).map { |s| s.to_i }[1]
    end
  rescue
    0
  end

  def self.tput_case?
    (RUBY_PLATFORM =~ /java/ || !STDIN.tty? && ENV['TERM']) && shell_command_exists?('tput')
  end

  def self.stty_case?
    STDIN.tty? && shell_command_exists?('stty')
  end

  def self.shell_command_exists?(command)
    ENV['PATH'].split(File::PATH_SEPARATOR).any?{|d| File.exists? File.join(d, command) }
  end
end
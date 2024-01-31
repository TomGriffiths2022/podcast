class PodcastDisplay

  def initialize(entry)
    @entry = entry
    @pretty = Pastel.new
    @pretty_title = @pretty.red(entry.title)
    # puts @display.yellow("Summary: #{@entry.summary}")
    # puts @display.green("Audio URL: #{@entry.audio_url}")
    # puts @display.cyan("Date Published: #{@entry.published}")
    # puts @display.magenta("Duration: #{@entry.duration}")
  end
  
end
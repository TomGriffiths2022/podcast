class PodcastFormatter
  # all uppercase is a constant
  SPACER = ' '

  def initialize(entry)
    @entry = entry
    @pretty = Pastel.new
  end

  def display
    # using the tty-box toolkit to display the information
    box = TTY::Box.frame(width: 30, height: 10, title: {top_left: "#{display_title}", bottom_right: "#{display_audio_url}"}) do
      "#{display_author}\n#{display_summary}\n#{display_published}\n#{display_duration}".strip
    end
    print box
  end

  private

  def display_title
    @pretty.magenta(truncate("Title: #{@entry.title}"))
  end

  def display_author
    @pretty.red(truncate("Author(s): #{(@entry.author)}"))
  end

  def display_summary
    # using the strip_html_tags method to remove the HTML from within the string
    @pretty.cyan(truncate("Summary: #{remove_advertising_inquiries_and_sign_up_from_string((strip_html_tags(@entry.summary)))}").strip) # HERE try to truncate and remove advertising bit
  end

  def display_audio_url
    @pretty.white("Audio URL: #{(@entry.audio_url)}")
  end

  def display_published
    display_date = @entry.published.strftime("%-d %B %Y")
    @pretty.magenta("Date published: #{display_date}")
  end

  def display_duration
    # converting the episode duration to the nearest minute
    duration_in_minutes = (@entry.duration.to_i / 60).round(half: :up).to_s
    @pretty.yellow("Duration: #{duration_in_minutes} minutes")
  end

  # def left_pad(str, indentation: 0)
  #   "#{SPACER*indentation}#{str}"
  # end

  def strip_html_tags(str)
    str = str.gsub(/<\/?[^>]*>/, "")
  end

  def remove_advertising_inquiries_and_sign_up_from_string(str)
    str = str.gsub("Advertising Inquiries: https://redcircle.com/brandsPrivacy & Opt-Out: https://redcircle.com/privacy", "").gsub("Sign Up: Ruby Dev Summit", "")
  end

  def truncate(string, max: 200)
    string.length > max ? "#{string[0...max]}..." : string
  end
end
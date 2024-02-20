require_relative 'feed'

### SETUP METHODS ###
def get_user_selection(user_choice, options_array)
  case user_choice.to_i
  when 1
    puts Pastel.new.on_green("Playing #{options_array.first.title}....")
    option_one = fork do
      # splitting the process into a fork to be able to isolate the signal for terminating
      Signal.trap("TERM") do
      end
      exec "mpg123 #{options_array.first.audio_url}"
    end
    # detaches from the parent process in order to be able to terminate
    Process.detach(option_one)
    user_listening_loop(option_one) 
  when 2
    puts Pastel.new.on_green("Playing #{options_array[1].title}....")
    option_two = fork do
      # splitting the process into a fork to be able to isolate the signal for terminating
      Signal.trap("TERM") do
      end
      exec "mpg123 #{options_array[1].audio_url}"
    end
    Process.detach(option_two)
    user_listening_loop(option_two) 
  when 3
    puts Pastel.new.on_green("Playing #{options_array.last.title}....")
    option_three = fork do
      # splitting the process into a fork to be able to isolate the signal for terminating
      Signal.trap("TERM") do
      end
      exec "mpg123 #{options_array.last.audio_url}"
    end
    Process.detach(option_three)
    user_listening_loop(option_three)
  else
    raise ArgumentError, "Unknown option #{user_choice}, please choose from 1, 2 or 3"
  end 
end

def user_listening_loop(chosen_option)
  # passing in which option to loop on
  loop do
    # put a prompt on screen to ask if the user wants to continue listening
    puts Pastel.new.on_red("To exit playback, press E")
    exit_playback = gets.upcase.chomp.to_s
    if exit_playback == 'E'
      # using the E key as the kill command to end the process
      puts Pastel.new.magenta.on_white("Ended the playback")
      Process.kill("TERM",chosen_option)
      break
    else
      # if user does not input E then display the message and return to the beginning of the loop
      puts Pastel.new.on_blue("Unknown option entered")
    end
  end
end

### SUB-PROGRAM ###
podcast = PodcastFeed.initialize_from_url('https://feeds.redcircle.com/c55cf02c-7b36-4f73-bb56-48cc5fc184a0')

# displays all episodes in the feed:
# podcast.episodes.each do |episode|
#   PodcastFormatter.new(episode).display
# end

# initialise the creation of the PodcastFeed object based on the url given
options = PodcastFeed.listening_options_to_user(podcast.recent_episodes)
puts Pastel.new.white.on_magenta("Which recent episode would you like to listen too?: 1, 2 or 3 (or EXIT to quit)")

loop do
  begin
    # determines the user's choice of which of the 3 latest episodes they would like to hear
    user_selection = gets.chomp
    break if user_selection == 'EXIT'
    # passing in the user's choice as well as the array of episode options to choose from
    get_user_selection(user_selection.to_i, options)
    break
  rescue ArgumentError => e
    puts Pastel.new.white.on_red("#{e.message}")
  end
end
require_relative 'feed'

### SETUP METHODS ###
def get_user_selection(user_choice, options_array)
  case user_choice.to_i
  when 1
    puts Pastel.new.red("Playing #{options_array.first.title}....")
    option_one = fork do
      # splitting the process into a fork to be able to isolate the signal for terminating
      Signal.trap("TERM") do
      end
      exec "mpg123 #{options_array.first.audio_url}"
    end
    # detaches from the parent process in order to be able to terminate
    Process.detach(option_one)
    user_input_loop(option_one) 
  when 2
    puts Pastel.new.red("Playing #{options_array[1].title}....")
    option_two = fork do
      # splitting the process into a fork to be able to isolate the signal for terminating
      Signal.trap("TERM") do
      end
      exec "mpg123 #{options_array[1].audio_url}"
    end
    Process.detach(option_two)
    user_input_loop(option_two) 
  else
    puts Pastel.new.red("Playing #{options_array.last.title}....")
    option_three = fork do
      # splitting the process into a fork to be able to isolate the signal for terminating
      Signal.trap("TERM") do
      end
      exec "mpg123 #{options_array.last.audio_url}"
    end
    Process.detach(option_three)
    user_input_loop(option_three) 
  end 
end

def user_input_loop(chosen_option)
  # passing in which option to loop on
  loop do
    # put a prompt on screen to ask if the user wants to continue listening
    puts Pastel.new.magenta.on_white("To exit playback, press E")
    exit_playback = gets.upcase.chomp.to_s
    if exit_playback == 'E'
      # using the E key as the kill command to end the process
      puts Pastel.new.magenta.on_white("Ended the playback")
      Process.kill("TERM",chosen_option)
      break
    else
      # if user does not input E then display the message and return to the beginning of the loop
      puts Pastel.new.magenta.on_white("Unknown option entered")
    end
  end
end

### SUB-PROGRAM ###
podcast = PodcastFeed.initialize_from_url('https://feeds.redcircle.com/c55cf02c-7b36-4f73-bb56-48cc5fc184a0')

# displays all episodes in the feed:
# podcast.episodes.each do |episode|
#   PodcastFormatter.new(episode).display
# end
options = PodcastFeed.listening_options_to_user(podcast.recent_episodes)
puts Pastel.new.magenta.on_white("Which recent episode would you like to listen too?: 1, 2 or 3")

user_selection = gets.chomp

get_user_selection(user_selection, options)
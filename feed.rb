require 'feedjira'
require 'pry'
require 'httparty'
require 'json'
require 'pastel'
require 'tty-box'

require_relative 'episode'
require_relative 'podcast_formatter'

class PodcastFeed

  attr_accessor :title, :summary, :url, :episodes, :recent_episodes

  def initialize
    # create the initialised podcast feeds to be stored as json object
    @title = nil
    @summary = nil
    @url = nil
    @episodes = []
    @recent_episodes = []
  end

  def self.initialize_from_url(url)
    new_feed = PodcastFeed.new()
    xml = HTTParty.get(url).body
    parsed_podcast = Feedjira.parse(xml)
    parsed_podcast.entries.each do |entry|
      episode = PodcastEpisode.new(title: entry.title,
                                   author: entry.itunes_author, 
                                   summary: entry.summary, 
                                   published: entry.published, 
                                   audio_url: entry.enclosure_url, 
                                   duration: entry.itunes_duration)
      new_feed.episodes << episode
    end
    new_feed.recent_episodes = most_recent_episodes(new_feed.episodes)
    new_feed
  end

  def self.listening_options_to_user(recent_episodes)
    recent_episodes.each_with_index do |episode, index|
      puts "Episode #{index + 1}: "
      PodcastFormatter.new(episode).display
    end
  end


  private

  def self.most_recent_episodes(feed_episodes)
    feed_episodes.sort_by { |episode| episode.published }
    recent_episodes = feed_episodes.first(3)
  end

  def self.get_user_selection(user_selection)
    case user_selection.to_i
    when 1
      # puts "Playing #{options.first.audio_url}...."
      puts "Playing file_example...."
      option_one = fork do
        # splitting the process into a fork to be able to isolate the signal for terminating
        Signal.trap("TERM") do
          puts "Ended the playback"
        end
        exec 'mpg123 file_example_MP3_1MG.mp3'
      end
      # detaches from the parent process in order to be able to terminate
      Process.detach(option_one)
    when 2
      # implement once we can extract the audio to play
      # options[1]
    else
      # implement once we can extract the audio to play
      # options.last
    end

    loop do
      # put a prompt on screen to ask if the user wants to continue listening
      puts Pastel.new.magenta.on_white("To exit playback, press E")
      exit_playback = gets.upcase.chomp.to_s
      if exit_playback == 'E'
        # using the E key as the kill command to end the process
        Process.kill("TERM",option_one)
        break
      else
        # if user does not input E then display the message and return to the beginning of the loop
        puts Pastel.new.magenta.on_white("Unknown option entered")
      end
    end
  end

end

podcast = PodcastFeed.initialize_from_url('https://feeds.redcircle.com/c55cf02c-7b36-4f73-bb56-48cc5fc184a0')
# displays all episodes in the feed:
# podcast.episodes.each do |episode|
#   PodcastFormatter.new(episode).display
# end
options = PodcastFeed.listening_options_to_user(podcast.recent_episodes)
puts Pastel.new.magenta.on_white("Which recent episode would you like to listen too?: 1, 2 or 3")

user_selection = gets.chomp
PodcastFeed.get_user_selection(user_selection)




# display interesting things about the podcast itself
# what is the title of the last three episodes, and some intersting things about them and make it pretty
# give a command prompt to ask which one we want to play, from these sorted episodes

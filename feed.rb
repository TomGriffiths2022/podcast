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
end







# display interesting things about the podcast itself
# what is the title of the last three episodes, and some intersting things about them and make it pretty
# give a command prompt to ask which one we want to play, from these sorted episodes

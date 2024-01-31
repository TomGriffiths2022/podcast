require 'feedjira'
require 'pry'
require 'httparty'
require 'json'
require 'pastel'

require_relative 'episode'
require_relative 'podcast_display'

class PodcastFeed

  attr_accessor :title, :summary, :url, :episodes

  def initialize
    # create the initialised podcast feeds to be stored as json object
    @title = nil
    @summary = nil
    @url = nil
    @episodes = []
  end

  def self.initialize_from_url(url)
    new_feed = PodcastFeed.new()
    xml = HTTParty.get(url).body
    parsed_podcast = Feedjira.parse(xml)
    # look at podcast itself
    new_feed.title = parsed_podcast.title
    new_feed.summary = parsed_podcast.description
    new_feed.url = parsed_podcast.url
    parsed_podcast.entries.each do |entry|
      episode = PodcastEpisode.new(title: entry.title,
                                   author: entry.itunes_author, 
                                   summary: entry.summary, 
                                   published: entry.published, 
                                   audio_url: entry.enclosure_url, 
                                   duration: entry.itunes_duration)
      new_feed.episodes << episode
    end
    new_feed
  end

  # def self.rss_feeder(feed_url)
    
  #   xml = HTTParty.get(feed_url).body
  #   feed = Feedjira.parse(xml)
  #   binding.pry
  #   feed.entries.each do |entry|
  #     PodcastFeed.new(entry)

  #   end

  #   # Looking at the methods on the Feedjira feed, the body of the feed can
  #   # be split into its attributed
  #   puts "Title of the feed is #{feed.entries.title}"
  #   puts "Summary of the feed is #{feed.entries.summary}"
  #   puts "URL of the feed is #{feed.entries.url}"
  # end

  # def self.write_feed_to_file(feeds:)
  #   file = File.read('feeds.json')
  #   array = JSON.parse(file)
  #   array["feeds"] = []
  #   # Add each feed to the 'feeds' array
  #   feeds.each do |feed|
  #     array["feeds"] << feed
  #   end
  # end

  # rss_feeder('https://feeds.redcircle.com/c55cf02c-7b36-4f73-bb56-48cc5fc184a0')
end

podcast = PodcastFeed.initialize_from_url('https://feeds.redcircle.com/c55cf02c-7b36-4f73-bb56-48cc5fc184a0')
puts podcast.title
puts podcast.summary
puts podcast.url
podcast.episodes.each do |episode|
  # puts "*#{episode.title}"
  binding.pry
  PodcastDisplay.new(episode).pretty_title
end

puts "Last 3 titles in the feed: #{podcast.episodes}"

# display interesting things about the podcast itself
# what is the title of the last three episodes, and some intersting things about them and make it pretty
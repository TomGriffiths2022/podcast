require 'feedjira'
require 'pry'
require 'httparty'
require 'json'

class PodcastFeed

  def initialize(feed)
    # create the initialised podcast feeds to be stored a json object
    feed
  end

  attr_accessor :podcast_feed

  def self.rss_feeder(feed_url)
    
    xml = HTTParty.get(feed_url).body
    feed = Feedjira.parse(xml)
    binding.pry
    feed.entries.each do |entry|

    end

    # Looking at the methods on the Feedjira feed, the body of the feed can
    # be split into its attributed
    puts "Title of the feed is #{feed.entries.title}"
    puts "Title of the feed is #{feed.entries.title}"
    puts "Title of the feed is #{feed.entries.title}"
  end

  def self.write_feeds_to_file(feeds:)
    file = File.read('feeds.json')
    array = JSON.parse(file)
    array["feeds"] = []
    # Add each feed to the 'feeds' array
    feeds.each do |feed|
      array["feeds"] << feed
    end
  end

  rss_feeder('https://feeds.redcircle.com/c55cf02c-7b36-4f73-bb56-48cc5fc184a0')
end
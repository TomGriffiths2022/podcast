class PodcastEpisode

  attr_accessor :title, :author, :summary, :audio_url, :published, :duration

  def initialize(title: nil, author: nil, summary: nil, audio_url: nil, published: nil, duration: nil)
    @title = title
    @author = author
    @summary = summary
    @audio_url = audio_url
    @published = published
    @duration = duration
    # look at important info to extract
  end

  def to_s
    # override the to_s method as the puts command will look for a string
    @title
  end
end
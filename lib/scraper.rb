require 'nokogiri'
require 'open-uri'

class Scraper

  def self.scrape
    doc = Nokogiri::HTML(open(base_url))
    parse(doc)
  end

  def self.parse(doc)
    return doc.css(css_selector).map do |link|
      [link.content.strip, link.attr("href")]
    end
  end

end

class NewRelicScraper < Scraper

  def self.base_url
    'http://newton.newtonsoftware.com/career/CareerHome.action?clientId=4028f88b20d6768d0120f7ae45e50365'
  end

  def self.css_selector
    '#gnewtonCareerBody a'
  end

end

class CrowdCompassScraper < Scraper
  def self.base_url
    'https://ch.tbe.taleo.net/CH06/ats/servlet/Rss?org=CVENT2&cws=40'
  end

  def self.css_selector
    'channel item'
  end

  def self.parse(doc)
    return doc.css(css_selector).map do |link|
      [(link/'title').first.content, link.children[2].content.strip]
    end
  end
end

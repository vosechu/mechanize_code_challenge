require 'nokogiri'
require 'open-uri'

class Scraper

  def self.scrape
    doc = Nokogiri::HTML(open(base_url))
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

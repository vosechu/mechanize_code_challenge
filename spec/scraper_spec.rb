require 'rspec'
require './lib/scraper'

describe "Scraper" do
  before(:each) do
    @scraper = Scraper
  end

  it "should be able to scrape" do
    @scraper.should respond_to :scrape
  end
end

describe "NewScraper" do
  context "when descended from Scrape" do
    before(:each) do
      @scraper = Class.new(Scraper)
    end

    it "should respond_to to scrape" do
      @scraper.should respond_to :scrape
    end
  end

  context "when it has valid base_url and css_selector methods" do
    before(:each) do
      @scraper = Class.new(Scraper) do
        def self.base_url
          'http://newton.newtonsoftware.com/career/CareerHome.action?clientId=4028f88b20d6768d0120f7ae45e50365'
        end

        def self.css_selector
          '#gnewtonCareerBody a'
        end
      end
    end

    it "should respond to descended methods" do
      @scraper.should respond_to :base_url
      @scraper.should respond_to :css_selector
    end

    it "should be able to scrape correctly" do
      @nr_scraper = NewRelicScraper
      @scraper.scrape.should eq(@nr_scraper.scrape)
    end
  end
end

describe "NewRelicScraper" do
  before(:each) do
    @scraper = NewRelicScraper
  end

  it "should comply with the interface" do
    @scraper.should respond_to :scrape
    @scraper.should respond_to :base_url
    @scraper.should respond_to :css_selector
  end

  it "should format scraped results into an array" do

  end
end
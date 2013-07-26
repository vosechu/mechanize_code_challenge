require 'rspec'
require 'vcr'
require './lib/scraper'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

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

  context "when it has valid base_url and css_selector methods", :vcr do
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

describe "NewRelicScraper", :vcr do
  before(:each) do
    @scraper = NewRelicScraper
  end

  it "should comply with the interface" do
    @scraper.should respond_to :scrape
    @scraper.should respond_to :base_url
    @scraper.should respond_to :css_selector
  end

  it "should format scraped results into an array" do
    jobs = @scraper.scrape
    jobs.first.should eq(["Agent SDK Engineer", "http://newton.newtonsoftware.com/career/JobIntroduction.action?clientId=4028f88b20d6768d0120f7ae45e50365&id=8a42a12b3fa43372013fbf737b7a6b21&gnewtonResize=http://newton.newtonsoftware.com/career/GnewtonResize.htm&source="])
    jobs.should be_a Array
  end
end

describe "CrowdCompassScraper", :vcr do
  before(:each) do
    @scraper = CrowdCompassScraper
  end

  it "should be able to get an array of jobs" do
    jobs = @scraper.scrape
    jobs.first.should eq(["Front End Web Developer", "http://ch.tbe.taleo.net/CH06/ats/careers/requisition.jsp?org=CVENT2&cws=40&rid=784"])
    jobs.should be_a Array
  end
end
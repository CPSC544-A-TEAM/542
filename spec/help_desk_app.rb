require "json"
require "selenium-webdriver"
require "rspec"
require 'dotenv'
include RSpec::Expectations

describe "Helpy" do

  Dotenv.load

  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "https://mseateam.herokuapp.com"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  after(:each) do
    @driver.quit
  end

  it "should login to the helpdesk account" do
    @driver.get(@base_url + "/en/users/sign_in")
    sleep 1
    @driver.find_element(:id, "user_email").clear
    @driver.find_element(:id, "user_email").send_keys  "sagerimal@csu.fullerton.edu"
    @driver.find_element(:id, "user_password").clear
    @driver.find_element(:id, "user_password").send_keys "Sage521802"
    @driver.find_element(:name, "commit").click
    sleep 2
    expect(@driver.title).to eq("MSE Team")
  end


end

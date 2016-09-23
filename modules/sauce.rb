#Saucelab module
#Browserstack module
#Keep it in one place, make it simple
require 'selenium-webdriver'


module Saucy


  def define(type)

    type=type.to_sym
    browser_stack_url = "http://#{$browserstack_username}:#{$browserstack_api}@hub.browserstack.com/wd/hub"

    case type

      when :JSProfile
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile.add_extension File.join("../JS/JSErrorCollector.xpi")
        @driver = Selenium::WebDriver.for :firefox, :profile => profile
        return @driver

      when :JSRemote
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile.add_extension File.join("../JS/JSErrorCollector.xpi")
        caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
        caps.platform = "Windows 7"
        caps.version = '28'
        return @driver


      when :headless
        require 'phantomjs'
        @driver= Selenium::WebDriver.for :phantomjs
        return @driver

      when :local
        @driver = Selenium::WebDriver.for :firefox
        return @driver

      when :safari
        caps = Selenium::WebDriver::Remote::Capabilities.safari
        caps['platform'] = 'OS X 10.11'
        caps['version'] = '9.0'

      when :"jd chrome"
        Selenium::WebDriver::Chrome.driver_path = File.path('/Users/jason/.rvm/bin/chromedriver')
        caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => ["test-type"]})
        @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
        return @driver

      when :"local chrome"
        # Selenium::WebDriver::Chrome.driver_path = File.path('/Users/jason/.rvm/bin/chromedriver')
        caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => ["test-type"]})
        @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
        return @driver

      when :ff, :firefox, :Firefox
        caps = Selenium::WebDriver::Remote::Capabilities.firefox
        caps.platform = "Windows 8"
        caps.version = '34'

      when :chrome, :Chrome, :sauce_chrome
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps["chromedriverVersion"] = "2.20"
        caps['platform'] = 'Windows 10'
        caps['version'] = '49.0'

      when :chrome_mac, :mac
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps['platform'] = 'OS X 10.11'
        caps['version'] = '50.0'
        caps['screenResolution'] = '1600x1200'


      when :"ie 10", :"Internet Explorer", :IEv10, :ie10
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
        caps.platform = 'Windows 8'
        caps.version = '10'

      when :"ie 9", :IE9, :"Internet Explorer 9", :IEv9, :ie9
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
        caps.platform = 'Windows 7'
        caps.version = '9'

      when :"ie 11", :IE11, :"Internet Explorer 11", :IEv11, :ie11
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
        caps.platform = 'Windows 10'
        caps.version = '11.0'
        caps["iedriverVersion"] = "2.48.0"

      when :"IOS 7", :IPHONE, :iphone
        caps = Selenium::WebDriver::Remote::Capabilities.iphone
        caps.platform = 'linux'
        caps.version = '4'
        caps['device-orientation'] = 'portrait'


      when :"IOS 8", :Iphone6, :iphone6
        caps = Selenium::WebDriver::Remote::Capabilities.new
        caps[:browserName] = 'iPhone'
        caps[:platform] = 'MAC'
        caps['device'] = 'iPhone 5'
        caps["record-screenshots"]= false
        caps["browserstack.debug"] = "true"
        @driver = Selenium::WebDriver.for(:remote,
                                          :url => browser_stack_url,
                                          :desired_capabilities => caps)
        return @driver

      when :galaxy, :Galaxy, :S5
        caps = Selenium::WebDriver::Remote::Capabilities.new
        caps[:browserName] = 'android'
        caps[:platform] = 'ANDROID'
        caps['device'] = 'Samsung Galaxy S5'
        caps["browserstack.debug"] = "true"
        @driver = Selenium::WebDriver.for(:remote,
                                          :url => browser_stack_url,
                                          :desired_capabilities => caps)

        return @driver

      when :all
        caps = ENV['caps']
        if caps=='internet_explorer'
          caps= Selenium::WebDriver::Remote::Capabilities.internet_explorer
        elsif caps=='chrome'
          caps = Selenium::WebDriver::Remote::Capabilities.chrome
        elsif caps=="iphone"
          caps = Selenium::WebDriver::Remote::Capabilities.iphone
        end
        caps.platform =ENV['caps.platform']
        caps.version = ENV['caps.version']
    end

    #Pass caps here to manipulate meta-data
    #Max duration is the time in sec a script will run, prevents from running indefinitely
    caps["video-upload-on-pass"]= false
    caps["record-screenshots"]= false
    caps['record-logs'] = false
    caps["capture-html"]= false
    caps["max-duration"]= 180
    caps["public"]= "team"
    caps["seleniumVersion"]= "2.48.2"
    caps[:name]=inspect.split(":")[0].gsub("#<", "")

    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "",
        :desired_capabilities => caps)

  end
end

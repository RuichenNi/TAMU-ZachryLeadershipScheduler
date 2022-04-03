require 'nokogiri'
require 'date'
require 'net/http'
require 'json'
require 'uri'
require 'logger'

module CourseScraper

  def self.get_terms
    s = PrivateCourseScraper.new
    response = s.do_request('https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/classSearch/getTerms?searchTerm=&offset=1&max=20', :get)
    JSON.parse(response.body)
  end
  
  def self.get_subjects(term_code)
    s = PrivateCourseScraper.new
    s.set_term_code_cookie(term_code)
    # After testing, the ?term query param does nothing, but just in case they change it later, we'll include it
    response = s.do_request("https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/classSearch/get_subject?term=#{term_code}&offset=1&max=9999999", :get)
    JSON.parse(response.body)
  end
  
  def self.get_courses(term_code, subject)
    s = PrivateCourseScraper.new
    s.set_term_code_cookie(term_code)
    page_offset = 0
    page_max_size = 100
    courses = []
    response = s.do_request("https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/searchResults/searchResults?txt_subject=#{subject}&txt_term=#{term_code}&pageOffset=#{page_offset}&pageMaxSize=#{page_max_size}", :get)
    json_response = JSON.parse(response.body)
    total_count = json_response['totalCount']
    courses += json_response['data']
    while page_offset < total_count
      page_offset += page_max_size
      response = s.do_request("https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/searchResults/searchResults?txt_subject=#{subject}&txt_term=#{term_code}&pageOffset=#{page_offset}&pageMaxSize=#{page_max_size}", :get)
      json_response = JSON.parse(response.body)
      courses += json_response['data']
    end
    courses
  end
  
  class PrivateCourseScraper
    METHOD_MAP = {
    :get    => Net::HTTP::Get,
    :post   => Net::HTTP::Post,
    :put    => Net::HTTP::Put,
    :delete => Net::HTTP::Delete
    }
    
    def initialize
      @cookie_map = {}
      set_initial_cookie
    end
    
    def set_initial_cookie
      do_request('https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/term/termSelection?mode=search', :get)
    end
    
    def set_term_code_cookie(term_code)
      do_request('https://compassxe-ssb.tamu.edu/StudentRegistrationSsb/ssb/term/search?mode=search', :post, {'term' => term_code})
    end
  
    def do_request(uri_string, http_method, form_data = nil)
      uri = URI.parse(uri_string)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      request = METHOD_MAP[http_method].new(uri.request_uri)
      request['Cookie'] = cookie_map_to_s
      if form_data
        request.set_form_data(form_data)
      end
      response = http.request(request)
      if response.kind_of? Net::HTTPSuccess
        add_to_cookie_map(response.get_fields('set-cookie'))
        response
      else
        raise StandardError, "CourseScraper Web Request Failed\n\tURI #{uri_string}\n\tCode #{response.code}"
      end
    end
    
    def add_to_cookie_map(cookie_strings)
      cookie_strings.each{|c_string| @cookie_map[c_string.split('=')[0]] = c_string}
    end
    
    def cookie_map_to_s
      @cookie_map.map{|k, v| v}.join(', ')
    end 
  end
end
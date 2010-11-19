$:.unshift "#{File.dirname(__FILE__)}/../../lib"

require 'test/unit'
require 'hoydaa/file_store'
require 'hoydaa/net_http_cache'

class NetHttpCacheTest < Test::Unit::TestCase

  def test_request_should_cache
    Hoydaa::Cache.cache(/^http:\/\/www\.time\.gov\/timezone.cgi.*/, :expires => 10, :store => Hoydaa::FileStore.new)
    fetch1 = Net::HTTP.get(URI.parse("http://www.time.gov/timezone.cgi?Pacific/d/-8")); sleep 2
    fetch2 = Net::HTTP.get(URI.parse("http://www.time.gov/timezone.cgi?Pacific/d/-8")); sleep 9
    fetch3 = Net::HTTP.get(URI.parse("http://www.time.gov/timezone.cgi?Pacific/d/-8"))
    assert_equal fetch1, fetch2
    assert_not_equal fetch2, fetch3
  end

end
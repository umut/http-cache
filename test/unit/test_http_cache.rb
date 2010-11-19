$:.unshift "#{File.dirname(__FILE__)}/../../lib"

require 'test/unit'
require 'hoydaa/http_cache'
require 'hoydaa/memory_store'

class HttpCacheTest < Test::Unit::TestCase

  def setup
    Hoydaa::Cache.clear_cache!
    Hoydaa::Cache.cache(/^http:\/\/www\.time\.gov\/timezone.cgi.*/, :expires => 10, :store => Hoydaa::MemoryStore.new)
  end

  def test_registered_pattern_should_be_cacheable
    assert Hoydaa::Cache.cacheable?('http://www.time.gov/timezone.cgi?Pacific/d/-8')
  end

  def test_content_should_come_from_cache
    Hoydaa::Cache.store("http://www.time.gov/timezone.cgi?Pacific/d/-8", "deneme1")

    assert_not_nil Hoydaa::Cache.cached?("http://www.time.gov/timezone.cgi?Pacific/d/-8"); sleep 5
    assert_not_nil Hoydaa::Cache.cached?("http://www.time.gov/timezone.cgi?Pacific/d/-8"); sleep 6
    assert_nil Hoydaa::Cache.cached?("http://www.time.gov/timezone.cgi?Pacific/d/-8")
  end

end
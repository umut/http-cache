require 'singleton'
require 'net/http'

module Hoydaa

  class Cache
    def self.method_missing(method, *args, &block)
      Hoydaa::Registry.instance.send(method, *args, &block)
    end
  end

  class Registry
    include Singleton

    attr_accessor :patterns, :log

    def initialize
      self.patterns = {}
    end

    def clear_cache!
      self.patterns = {}
    end

    def cacheable?(pattern)
      pattern = normalize_pattern(pattern)
      return patterns[pattern] if patterns.has_key?(pattern)
      patterns.keys.find_all { |p| p.respond_to?(:match) }.each do |regex|
        return patterns[regex] if pattern.to_s.match regex
      end
      nil
    end

    def cached?(uri)
      uri          = normalize_pattern(uri)
      cache_config = cacheable?(uri)
      return nil if not cache_config

      if (Time.now.to_f > cache_config[:store].last_modified(uri.to_s) + cache_config[:expires])
        cache_config[:store].remove(uri.to_s)
        return nil
      end

      cache_config[:store].retrieve(uri.to_s)
    end

    def store(uri, content)
      uri = normalize_pattern(uri)
      cacheable?(uri)[:store].store(uri.to_s, content)
    end

    def cache(pattern, options)
      self.patterns[normalize_pattern(pattern)] = options
    end

    def normalize_pattern(pattern)
      case pattern
        when URI then
          pattern
        when Regexp then
          pattern
        else
          pattern = 'http://' + pattern unless pattern.match('^https?://')
          URI.parse(pattern)
      end
    end
  end

end
require 'rubygems'

module Hoydaa

  # Hoydaa::MemoryStore is a basic memory store. mostly for testing purposes.
  #
  # Example:
  #
  #    repo = Hoydaa::MemoryStore.new
  #    repo.store("id-of-the-resource", "content of the resource")
  #    repo.retrieve("id-of-the-resource")
  #
  class MemoryStore

    def initialize()
      clear_cache
    end

    def clear_cache
      @cache = {}
    end

    def last_modified(id)
      @cache[id][:last_modified]
    end

    def remove(id)
      @cache.delete id
    end

    def store(id, content)
      @cache[id] = {:content => content, :last_modified => Time.now.to_f}
    end

    def retrieve(id)
      return nil if not @cache[id]
      @cache[id][:content]
    end

  end

end
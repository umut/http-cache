require 'hoydaa/http_cache'

module Net

  class HTTP

    def HTTP.get(uri_or_host, path = nil, port = nil)
      if (Hoydaa::Cache.cacheable?(uri_or_host))
        rtn = Hoydaa::Cache.cached?(uri_or_host)
        return rtn if rtn
        rtn = get_response(uri_or_host, path, port).body
        Hoydaa::Cache.store(uri_or_host, rtn)
        rtn
      else
        get_response(uri_or_host, path, port).body
      end
    end

  end

end
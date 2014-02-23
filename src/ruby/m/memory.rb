module M
  class Memory
    def initialize()
      @db = {}
    end

    def put(namespace, key, value)
      @db[namespace] = {} unless @db.has_key?(namespace)
      @db[namespace][key] = value
    end

    def get(namespace, key)
      return @db[namespace][key]
    end
  end
end

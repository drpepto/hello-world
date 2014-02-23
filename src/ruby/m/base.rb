module M
  class Base
    @@ids = {}
    @@db = {}

    def initialize(namespace)
      @@ids[namespace] = 0 unless @@ids.has_key?(namespace)
      @@db[namespace] = {} unless @@db.has_key?(namespace)
      @db  = @@db[namespace]
      @ids = @@ids[namespace]
      @namespace = namespace
    end

    def create(val)
      id = next_id()
      val[:id] = id
      update(id, val)
      return [id]
    end

    def read_all()
      return @db.values
    end

    def update(id, val)
      @db[id] = val
      return [id]
    end

    def read(id)
      return @db[id]
    end

    def delete(id)
      @db.delete(id) if @db.has_key?(id)
      return [id]
    end

    def next_id
      @ids = @ids + 1
      return @ids
    end
  end
end

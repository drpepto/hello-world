require 'm/hello'
require 'm/memory'

module M
  class Builder
    include Singleton
    @persistance = M::Memory.new
    @cache = {}

    def set_persitance(p)
      @@persistance = p
    end

   HELLO = :hello

    def get_model(type)
      if(@cache.nil?)
        @cache = {
          HELLO => M::Hello.new
        }
      end
      return @cache[type] || nil
    end
  end
end

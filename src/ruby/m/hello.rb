require 'm/base'

module M
  class Hello < Base
    def initialize()
      @namespace = :hello
      super(@namespace)
    end
  end
end

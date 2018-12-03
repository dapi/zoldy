# frozen_string_literal: true

module XSemVer
  # Monkey patch SemVer to have fancy #to_s
  #
  class SemVer
    def to_s
      format('%M.%m.%p%s')
    end
  end
end

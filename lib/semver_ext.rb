# frozen_string_literal: true

module XSemVer
  class SemVer
    def to_s
      format('%M.%m.%p%s')
    end
  end
end

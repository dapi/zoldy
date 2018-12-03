# frozen_string_literal: true

class XSemVer::SemVer
  def to_s
    format('%M.%m.%p%s')
  end
end

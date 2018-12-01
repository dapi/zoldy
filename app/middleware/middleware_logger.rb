# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true
# rubocop:disable all

require 'puma/commonlogger'

# Logging middleware replacement of Puma::CommonLogger
#
# Log request with zold-specific data
#
class MiddlewareLogger < Puma::CommonLogger
  private

  def log(env, status, header, began_at)
    now = Time.now
    length = extract_content_length(header)

    remote_ip = env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'] || '-'

    score = env[:zold_score]
    remote_ip = "#{score.host}:#{score.port}" if score.present?
    msg = format(
      FORMAT,
      remote_ip,
      [env['HTTP_X_ZOLD_NETWORK'], env['HTTP_X_ZOLD_PROTOCOL']].compact.join('#'),
      now.strftime('%d/%b/%Y:%H:%M:%S %z'), env[REQUEST_METHOD], env[PATH_INFO], env[QUERY_STRING].empty? ? '' :
      "?#{env[QUERY_STRING]}",
      env['HTTP_VERSION'],
      status.to_s[0..3],
      length,
      now - began_at
    )

    write(msg, env)
  end

  def write(msg, env)
    logger = @logger || env['rack.errors']

    # Standard library logger doesn't support write but it supports << which actually
    # calls to write on the log device without formatting
    if logger.respond_to?(:write)
      logger.write(msg)
    else
      logger << msg
    end
  end
end

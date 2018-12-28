# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module HttpHeaders
  # HTTP header we add to each HTTP request, in order to inform
  # the other node about the score. If the score is big enough,
  # the remote node will add us to its list of remote nodes.
  SCORE_HEADER = 'X-Zold-Score'

  # HTTP header we add, in order to inform the node about our
  # version. This is done mostly in order to let the other node
  # reboot itself, if the version is higher.
  VERSION_HEADER = 'X-Zold-Version'

  # HTTP header we add, in order to inform the node about our
  # network. This is done in order to isolate test networks from
  # production one.
  NETWORK_HEADER = 'X-Zold-Network'

  # HTTP header we add, in order to inform the node about our
  # protocol.
  PROTOCOL_HEADER = 'X-Zold-Protocol'

  REPO_HEADER = 'X-Zold-Repo'

  HEADERS = [SCORE_HEADER, VERSION_HEADER, NETWORK_HEADER, PROTOCOL_HEADER, REPO_HEADER].freeze
end

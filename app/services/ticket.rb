require 'rest-client'
require 'json'

class Ticket
  attr_accessor :id,
                :priority,
                :status,
                :subject,
                :description

  def self.all(query = {})
    response = Request.search('tickets.json', query)
    if response['tickets']
      tickets = response.fetch('tickets').map { |ticket| Ticket.new(ticket) }
    end
    if response['previous_page']
      prev_pg = split_endpoint(response['previous_page'])
    end
    if response['next_page']
      next_pg = split_endpoint(response['next_page'])
    end
    [ tickets, response[:errors], prev_pg, next_pg ]
  end

  def self.find(id)
    response = Request.search("tickets/#{id}.json")
    Ticket.new(response['ticket'])
  end

  def self.split_endpoint(endpoint)
    # https://sparktrail.zendesk.com/api/v2/tickets.json?page=2&per_page=25
    # >>>
    # https://sparktrail.zendesk.com/api/v2/tickets.json
    # page=2&per_page=25
    # >>>
    # page=2
    # per_page=25
    # >>>
    # 2
    # 25
    query = endpoint.split('?').last.split('&')
    { page: query[0].split('=').last, per_page: query[1].split('=').last }
  end

  def initialize(args = {})
    args.each do |key, value|
      attr_name = key.to_s
      send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
    end
  end
end

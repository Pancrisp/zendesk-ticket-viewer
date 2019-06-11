class Ticket
  include Adapter

  attr_accessor :id,
                :requester_id,
                :assignee_id,
                :status,
                :subject,
                :description

  def self.all(query = {})
    response = Adapter::Zendesk.search('tickets.json', query)
    if response['tickets']
      tickets = response.fetch('tickets').map { |ticket| Ticket.new(ticket) }
    end

    if response['previous_page']
      prev_pg = param_values(response['previous_page'])
    end

    if response['next_page']
      next_pg = param_values(response['next_page'])
    end
    
    [ tickets, response[:errors], prev_pg, next_pg ]
  end

  def self.find(id)
    response = Adapter::Zendesk.search("tickets/#{id}.json")
    ticket = Ticket.new(response['ticket'])
    requester_id = response['ticket']['requester_id']
    assignee_id = response['ticket']['assignee_id']
    [ ticket, requester_id, assignee_id ]
  end

  def self.param_values(endpoint)
    # Retrieve parameter values from URLs with query strings
    query = endpoint.split('?').last.split('&')
    page = query[0].split('=').last
    per_page = query[1].split('=').last
    { page: page, per_page: per_page }
  end

  def initialize(args = {})
    # Set each key value pair from the JSON response
    # as an instance variable on the Ticket object
    args.each do |key, value|
      attr_name = key.to_s
      send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
    end
  end
end

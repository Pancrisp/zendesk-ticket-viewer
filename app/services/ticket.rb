require 'rest-client'
require 'json'

class Ticket
  attr_accessor :id,
                :priority,
                :status,
                :subject,
                :description

  def self.all
    response = Request.search("tickets.json")
    if response['tickets']
      tickets = response.fetch('tickets').map { |ticket| Ticket.new(ticket) }
    end
    [ tickets, response[:errors] ]
  end

  def self.find(id)
    response = Request.search("tickets/#{id}.json")
    Ticket.new(response['ticket'])
  end

  def initialize(args = {})
    args.each do |key, value|
      attr_name = key.to_s
      send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
    end
  end
end

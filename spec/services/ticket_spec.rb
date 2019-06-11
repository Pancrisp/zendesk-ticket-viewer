require 'rails_helper'

RSpec.describe Ticket, :type => :request do
  let(:ticket_json) { File.read('spec/fixtures/ticket.json') }

  describe ".initialize" do
    it 'creates a Ticket object' do
      response = JSON.parse(ticket_json)
      ticket = Ticket.new(response['ticket'])
      expect(ticket.id).to eql(2)
      expect(ticket.subject).to eql("hello")
      expect(ticket.description).to eql("123")
      expect(ticket.status).to eql("open")
      expect(ticket.requester_id).to eql(381228056034)
      expect(ticket.assignee_id).to eql(381228056034)
    end
  end
end

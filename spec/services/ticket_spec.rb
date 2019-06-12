require 'rails_helper'

RSpec.describe Ticket, :type => :request do
  let(:ticket_json) { File.read('spec/fixtures/ticket.json') }
  let(:tickets_json) { File.read('spec/fixtures/tickets.json') }
  let(:ticket) { Ticket.find(2) }
  let(:tickets) { Ticket.all(page: 2, per_page: 25) }
  let(:uri) { 'https://sparktrail.zendesk.com/api/v2/tickets/2.json?per_page=25' }
  let(:tickets_uri) { 'https://sparktrail.zendesk.com/api/v2/tickets.json?page=2&per_page=25' }
  
  describe 'self.all' do
    before { stub_request(:get, tickets_uri).to_return(status: 200, body: tickets_json) }

    it 'returns an array of tickets' do
      expect(tickets[0].count).to eq(3)
    end

    context 'only previous page present' do
      let(:tickets_prev) { File.read('spec/fixtures/tickets_prev.json') }
      before { stub_request(:get, tickets_uri).to_return(status: 200, body: tickets_prev) }
      
      it 'returns only previous page parameters' do
        expect(tickets[2]).to include(
          page: "1",
          per_page: "25"
        )
      end
    end
    
    context 'only next page present' do
      let(:tickets_next) { File.read('spec/fixtures/tickets_next.json') }
      before { stub_request(:get, tickets_uri).to_return(status: 200, body: tickets_next) }

      it 'returns only next page parameters' do
        expect(tickets[3]).to include(
          page: "3",
          per_page: "25"
        )
      end
    end

    context 'previous and next page present' do
      it 'returns previous page parameters' do
        expect(tickets[2]).to include(
          page: "1",
          per_page: "25"
        )
      end

      it 'returns next page parameters' do
        expect(tickets[3]).to include(
          page: "3",
          per_page: "25"
        )
      end
    end
  end

  describe 'self.find' do
    before { stub_request(:get, uri).to_return(status: 200, body: ticket_json) }

    it 'returns an instance of a ticket object' do
      expect(ticket[0]).to be_instance_of(Ticket)
    end

    it 'returns a ticket object with the correct values' do
      expect(ticket[0].id).to eql(2)
      expect(ticket[0].id).to eql(2)
      expect(ticket[0].subject).to eql("hello")
      expect(ticket[0].description).to eql("123")
      expect(ticket[0].status).to eql("open")
      expect(ticket[0].requester_id).to eql(381228056034)
      expect(ticket[0].assignee_id).to eql(381228056034)
    end

    it 'returns the correct requester id' do
      expect(ticket[1]).to eql(381228056034)
    end

    it 'returns the correct assignee id' do
      expect(ticket[2]).to eql(381228056034)
    end
  end

  describe 'self.param_values' do
    it 'returns a hash of parameters' do
      params = Ticket.param_values(tickets_uri)
      expect(params).to include(
        page: "2",
        per_page: "25"
      )
    end
  end

  describe ".initialize" do
    before { stub_request(:get, uri).to_return(status: 200, body: ticket_json) }

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

require 'rails_helper'

RSpec.describe 'Zendesk Adapter' do
  let(:ticket_json) { File.read('spec/fixtures/ticket.json') }
  let(:unauthenticated_json) { File.read('spec/fixtures/401.json') }
  let(:uri) { 'https://sparktrail.zendesk.com/api/v2/tickets/2.json?per_page=25' }
  
  describe '.search' do
    context 'authenticated'
      before { stub_request(:get, uri).to_return(status: 200, body: ticket_json) }

      it 'returns a JSON object' do
        response = Adapter::Zendesk.search('tickets/2.json')
          expect(response['ticket']).to include_json(
            id: 2,
            subject: "hello",
            description: "123",
            status: "open",
            requester_id: 381228056034,
            assignee_id: 381228056034
          )
      end
    end

    context 'unauthenticated' do
      before { stub_request(:get, uri).to_return(status: 401, body: unauthenticated_json) }

      it 'returns a hash with an error message' do
        response = Adapter::Zendesk.search('tickets/2.json')
        expect(response).to include_json(
          errors: {
            message: "Couldn't authenticate you"
          }
        )
      end
    end
  end

  describe '.errors' do
    before { stub_request(:get, uri).to_return(status: 401, body: unauthenticated_json) }
    
    it 'returns a hash with an error message' do
      response = Adapter::Zendesk.errors(unauthenticated_json)
      expect(response).to include_json(
        errors: {
          message: "Couldn't authenticate you"
        }
      )
    end
  end

  describe '.fetch_data' do
    context 'authenticated' do
      before { stub_request(:get, uri).to_return(status: 200, body: ticket_json) }

      it 'returns a JSON object' do
        response = Adapter::Zendesk.fetch_data('tickets/2.json')
        expect(response.first['ticket']).to include_json(
          id: 2,
          subject: "hello",
          description: "123",
          status: "open",
          requester_id: 381228056034,
          assignee_id: 381228056034
        )
      end

      it 'returns 200 ok' do
        response = Adapter::Zendesk.fetch_data('tickets/2.json')
        expect(response.last).to eql(200)
      end
    end
    
    context 'unauthenticated' do
      before { stub_request(:get, uri).to_return(status: 401, body: unauthenticated_json) }
      
      it 'returns could not authenticate message' do
        response = Adapter::Zendesk.fetch_data('tickets/2.json')
        expect(JSON.parse(response)).to include_json(
          error: "Couldn't authenticate you"
        )
      end

      it 'returns 401 authentication error' do
        response = Adapter::Zendesk.fetch_data('tickets/2.json')
        expect(response.code).to eql(401)
      end
    end
  end
end

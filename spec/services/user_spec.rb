require 'rails_helper'

RSpec.describe User, :type => :request do
  let(:user_json) { File.read('spec/fixtures/user.json') }
  let(:user) { User.find(2) }
  let(:uri) { 'https://sparktrail.zendesk.com/api/v2/users/2.json?per_page=25' }
  before { stub_request(:get, uri).to_return(status: 200, body: user_json) }
  
  describe 'self.find' do
    it 'returns an instance of a user object' do
      expect(user).to be_instance_of(User)
    end

    it 'returns the correct name' do
      expect(user.name).to eql("Ervin Chua")
    end
  end

  describe ".initialize" do
    it 'creates a User object' do
      response = JSON.parse(user_json)
      user = User.new(response['user'])
      expect(user.name).to eql("Ervin Chua")
    end
  end
end

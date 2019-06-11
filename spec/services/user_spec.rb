require 'rails_helper'

RSpec.describe User, :type => :request do
  let(:user_json) { File.read('spec/fixtures/user.json') }
  
  describe ".initialize" do
    it 'creates a User object' do
      response = JSON.parse(user_json)
      user = User.new(response['user'])
      expect(user.name).to eql("Ervin Chua")
    end
  end
end

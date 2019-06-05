class Request
  class << self
    BASE_URI = 'https://sparktrail.zendesk.com/api/v2/'

    def tickets
      response, status = fetch_data("tickets.json")
      status == 200 ? response : errors(response)
    end

    def ticket(id)
      response, status = fetch_data("tickets/#{id}.json")
      status == 200 ? response : errors(response)
    end

    def find_user(id)
      response, status = fetch_data("users/#{id}.json")
      status == 200 ? response: errors(response)
    end
    
    def errors(response)
      error = { errors: { status: response["status"], message: response["message"] } }
      response.merge(error)
    end

    def fetch_data(path)
      response = tickets_api[path].get
      [JSON.parse(response), response.code]
    end

    def tickets_api
      RestClient::Resource.new(
        BASE_URI,
        :user => Rails.application.credentials.zendesk[:username],
        :password => Rails.application.credentials.zendesk[:password],
        :headers => { params: { per_page: 25 } }
      )
    end
  end
end

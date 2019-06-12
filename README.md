# Zendesk Ticket Viewer - Internship Coding Challenge 2019

**Applicant name: Ervin Chua**

Developed and tested on `ruby-2.6.3` and `rails 5.2.3`

## Setup and usage

```bash
# Clone the repository
git clone git@github.com:Pancrisp/zendesk-ticket-viewer.git

# Install dependencies
cd zendesk-ticket-viewer && bundle install

# Run test suite
rspec spec

# Run app
rails s
```

**Zendesk API credentials**

The project uses encrypted credentials to store login details for accessing Zendesk APIs. I would never do this under normal circumstances, but I've included the decryption key in the repo for the purposes of this coding challenge. So the app should work out of the box without needing to configure ENV vars after cloning the repository.

**Zendesk Adapter**

Please restart the Rails server after changing credentials in the `zendesk_api` method in `app/adapters/zendesk.rb` to test API authentication, otherwise you'd get an uninitialized error on the Adapter module.

## Project navigation

These directories contain the code I've written for the coding challenge.
No need to look through the entire Rails project directory looking for my work.
Let me spare you from that misery, it's the least I could do. 🤪

```bash
zendesk-ticket-viewer
├── app
│    ├── adapters        # Zendesk API wrapper
│    ├── assets
│    ├── controllers
│    ├── services        # ticket and user services
│    └── views
└── spec
     ├── adapters        # stub requests for Zendesk API
     ├── fixtures        # fixtures for stubbing requests
     └── services
```

## Notes on application design

I approached this problem assuming the role of a client wanting to integrate Zendesk
services into their own products.

**Tickets and users as POROs, not ActiveRecord models**

Considering the app's sole task is to display ticket data retrieved from the Zendesk API,
there's no need to persist data. In my mind, saving the tickets would add additional overhead
when keeping the database in sync with the Zendesk API. As a result, the ticket and user services
are written as normal Ruby objects without inheriting from ActiveRecord.

**Testing a third party service (Zendesk API) with stubs**

Testing against external services have always made me go 😵
I've chosen not to test against the live API because it slows down the test suite a lot,
and have instead used stubs for testing requests to the Zendesk API.
I'm still not entirely familiar with this so some feedback will be greatly appreciated 👍

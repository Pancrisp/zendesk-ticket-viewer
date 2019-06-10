# Zendesk Ticket Viewer - Internship Coding Challenge 2019

Applicant name: Ervin Chua

Developed and tested on `ruby-2.6.3` and `rails 5.2.3`

## Setup and installation

Clone the repository and run bundle install

```
$ git clone git@github.com:Pancrisp/zendesk-ticket-viewer.git
$ cd zendesk-ticket-viewer && bundle install
```

**Zendesk API credentials**

The project uses encrypted credentials to store login details for accessing Zendesk APIs.
So the app should work without needing to configure ENV vars after cloning the repository.

## Project navigation

These directories contain the code I've written for the coding challenge.
No need to look through the entire Rails project directory looking for my work.
Let me spare you from that misery, it's the least I could do. 🤪

```
zendesk-ticket-viewer
├── app
│    ├── assets
│    ├── controllers
│    ├── services
│    └── views
└── spec
     ├── controllers
     ├── requests
     └── services
```

## Checklist

- [x] Connect to Zendesk API
- [x] Request the tickets for your account
- [x] Display them in a list, paginate when more than 25 are returned
- [x] Display individual ticket details
- [x] Error handling
- [x] Tests

## Notes

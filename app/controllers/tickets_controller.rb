class TicketsController < ApplicationController
  def index
    @tickets, @errors, @prev, @next = Ticket.all(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def show
    @ticket, requester_id, assignee_id = Ticket.find(params[:id])
    @requester = User.find(requester_id)
    @assignee = User.find(assignee_id)
  end
end

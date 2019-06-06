class TicketsController < ApplicationController
  def index
    @tickets, @errors = Ticket.all
  end

  def show
    @ticket = Ticket.find(params[:id])
    @user = User.find(381228056034)
  end
end

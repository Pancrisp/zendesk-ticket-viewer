class TicketsController < ApplicationController
  def index
    @tickets, @errors, @prev, @next = Ticket.all(
      :page => params[:page],
      :per_page => params[:per_page]
    )
  end

  def show
    @ticket = Ticket.find(params[:id])
    @user = User.find(381228056034)
  end
end

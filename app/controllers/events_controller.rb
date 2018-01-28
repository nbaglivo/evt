class EventsController < ApplicationController

  def index
    @events = Event.where(owner_id: current_user.id)
    json_response(@events)
  end

  private

  def event_params
    params.permit(:name, :date)
  end
end

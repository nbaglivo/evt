class EventsController < ApplicationController

  def index
    @events = Event.where(owner_id: current_user.id)
    json_response(@events)
  end

  def create
    @event = Event.create!(event_params.merge(owner_id:current_user.id))
    json_response(@event, :created)
  end

  private

  def event_params
    params.permit(:name, :date)
  end
end

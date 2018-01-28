class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  def index
    @events = Event.where(owner_id: current_user.id)
    json_response(@events)
  end

  def create
    @event = Event.create!(event_params.merge(owner_id:current_user.id))
    json_response(@event, :created)
  end

  def show
    json_response(@event)
  end

  private

  def event_params
    params.permit(:name, :date)
  end

  def user_events
    Event.where(owner_id: current_user.id)
  end

  def set_event
    @event = user_events.find(params[:id])
  end
end

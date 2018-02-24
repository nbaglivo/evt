class EventsController < ApplicationController
  before_action :set_event, only: [:show, :destroy, :update, :check]

  def index
    json_response(user_events.map{ |event| event_serializer(event) })
  end

  def create
    @event = Event.create!(event_params.merge(owner_id:current_user.id))
    json_response(event_serializer(@event), :created)
  end

  def show
    json_response(event_serializer(@event))
  end

  def update
    @event.update!(event_params)
    json_response(event_serializer(@event))
  end

  def destroy
    @event.destroy
    head :no_content
  end

  def check
    attendee = @event.attendees.detect{|attendee| attendee["email"] == email_param_for_check }
    attendee[:checked] = true if attendee
    @event.save
    json_response(event_serializer(@event))
  end

  private

  def event_serializer(event)
    event.slice(:id, :name, :date, :attendees)
  end

  def email_param_for_check
    params.require(:email)
  end

  def event_params
    data_keys = params[:attendees].collect{ |attendee| attendee[:data].try(:keys) } if params[:attendees]
    params.permit(:name, :date, attendees: [:email, data: data_keys])
  end

  def user_events
    Event.where(owner_id: current_user.id)
  end

  def set_event
    @event = user_events.find(params[:id])
  end
end

class ValidationRulesController < ApplicationController
  before_action :set_event, only: [:index, :create]

  def index
    json_response(validation_rules)
  end

  def create
    @rule = ValidationRule.create!(validation_rules_params.merge(event_id: @event.id))
    json_response(@rule, :created)
  end

  def validation_rules
    ValidationRule.where(event_id: @event.id)
  end

  def validation_rules_params
    params.permit(:validation_type, :name, :failure_message, :user_field)
  end

end

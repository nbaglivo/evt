class ValidationRulesController < ApplicationController
  before_action :set_event, only: [:index, :create, :destroy]
  before_action :set_rule, only: [:destroy]

  def index
    json_response(validation_rules)
  end

  def create
    @rule = ValidationRule.create!(validation_rules_params.merge(event_id: @event.id))
    json_response(@rule, :created)
  end

  def destroy
    @rule.destroy
    head :no_content
  end

  private

  def set_rule
    @rule = validation_rules.find(params[:validation_rule_id])
  end

  def validation_rules
    @event.validation_rules
  end

  def validation_rules_params
    params.permit(:validation_type, :name, :failure_message, :user_field)
  end

end

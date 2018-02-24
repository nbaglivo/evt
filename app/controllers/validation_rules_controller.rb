class ValidationRulesController < ApplicationController
  before_action :set_event, only: [:index]

  def index
    json_response(validation_rules)
  end

  def validation_rules
    @event.validation_rules
  end

end

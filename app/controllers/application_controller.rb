class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|

    error = "#{Message.missing_parameter(parameter_missing_exception.param)}"
    json_response(error, 422)
  end
end

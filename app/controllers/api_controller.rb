# frozen_string_literal: true

class ApiController < ActionController::Base
  #  remove security against CSRF attack for all requests in JSON format
  protect_from_forgery unless: -> { request.format.json? }
  # rescue all types of errors that may occur with the parameters defined in the API documentation
  rescue_from Apipie::ParamError, with: :render_invalid_param

  private

  def render_invalid_param(error)
    render json: { error: error.message }, status: :unprocessable_content
  end
end

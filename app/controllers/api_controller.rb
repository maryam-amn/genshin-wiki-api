# frozen_string_literal: true

class ApiController < ActionController::Base
  #  remove security against CSRF attack for all requests in JSON format
  protect_from_forgery unless: -> { request.format.json? }
  # rescue all types of errors that may occur with the parameters defined in the API documentation
  rescue_from Apipie::ParamError, with: :render_invalid_param
  # rescue any errors that might occur when the number of items per page is set to zero
  rescue_from Kaminari::ZeroPerPageOperation, with: :render_pagination_error
  private

  def render_invalid_param(error)
    render json: { error: error.message }, status: :unprocessable_content
  end
  def render_pagination_error(error)
    render json: { error: I18n.t("Api.error.pagination.value_per_page_is_set_to_zero"), details: { field: [ error.message ] } }, status: :unprocessable_content
  end
end

# frozen_string_literal: true

class ApiController < ActionController::Base
  #  remove security against CSRF attack for all requests in JSON format
  protect_from_forgery unless: -> { request.format.json? }
end

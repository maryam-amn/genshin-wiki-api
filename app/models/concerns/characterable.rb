# frozen_string_literal: true

module Characterable
    extend ActiveSupport::Concern

    included do
      has_one :character, as: :characterable, touch: true
    end
end

class BossCharacter < ApplicationRecord
  include Characterable
  delegate :name, :description, :rarity, :region, :characterable_type, to: :character, allow_nil: true

  validates :is_weekly_boss, presence: true, inclusion: { within: [ true, false ] }
  validates :location, presence: true
  validates :recommended_level, presence: true

  attr_accessor :region_location, :exact_location

  validates :region_location, inclusion: { in: [ "Liyue", "Fontaine", "Monstadt" ] }, allow_blank: true
  validates :exact_location, format: { with: /\A[a-zA-Z0-9 ]+\z/ }, allow_blank: true

  before_validation :set_location

  def set_location
    if region_location.present? && exact_location.present?
      self.location = "#{region_location} - #{exact_location}"
    else
      self.location
    end
  end
end

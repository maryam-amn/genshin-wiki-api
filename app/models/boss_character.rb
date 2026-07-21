class BossCharacter < ApplicationRecord
  include Characterable
  delegate :name, :description, :rarity, :region, :characterable_type, to: :character, allow_nil: true

  validates :is_weekly_boss, presence: true
  validates :location, presence: true
  validates :recommended_level, presence: true
end

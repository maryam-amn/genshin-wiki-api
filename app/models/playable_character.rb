class PlayableCharacter < ApplicationRecord
  include Characterable
  delegate :name, :description, :rarity, :region, to: :character

  validates :base_attack, presence: true
  validates :base_defense, presence: true
  validates :base_hp, presence: true

  def who_am_i
    puts "#{self.class.name}: #{name}"
  end
end

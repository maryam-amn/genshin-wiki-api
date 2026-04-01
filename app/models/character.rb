class Character < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true,  length: { minimum: 20 }
  validates :rarity, presence: true, numericality:  { only_integer: true }, inclusion: { in: 0..5 }

  # type is null but will be playable' or 'boss' in the future
  # type is a STI, we have to create PlayableCharacter and BossCharacter
end

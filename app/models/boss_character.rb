class BossCharacter < ApplicationRecord
  include Characterable
  delegate :name, :description, :rarity, :region, :characterable_type, to: :character, allow_nil: true

  validates :recommended_level, presence: true
  enum :fight_region_location, %w[ Liyue Montstadt Inazuma Sumeru Fontaine Natlan Nod-Krai Snezhnaya Khaenri'ah].index_by(&:itself)

  validates :fight_region_location, presence: { message: I18n.t("boss_characters.model_message_errors.must_be_presence_of_fight_region_location") }
  validates :fight_exact_location, format: { without: /[!@#$%^*()-=_+|;:<>?]/ },
            presence: { message: I18n.t("boss_characters.model_message_errors.character_presence") }
end

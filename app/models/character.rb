class Character < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true,  length: { maximum: 400 }
  validates :rarity, presence: true, numericality:  { only_integer: true }, inclusion: { in: 0..5 }
  enum :region, %w[ Fontaine Inazuma Liyue Montstadt Natlan  Sumeru ].index_by(&:itself)

  def self.ransackable_associations(_auth_object = nil)
    %w[rarity region]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[rarity region]
  end
end

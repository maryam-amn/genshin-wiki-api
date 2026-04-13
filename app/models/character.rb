class Character < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true,  length: { maximum: 400 }
  validates :rarity, presence: true, numericality:  { only_integer: true }, inclusion: { in: 0..5 }
  enum :region, %w[Liyue Fontaine Montstadt].index_by(&:itself)
end

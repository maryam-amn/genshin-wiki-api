ActiveAdmin.register Character do
  permit_params :name, :region, :rarity, :description

  filter :rarity, as: :check_boxes, collection: proc { Character.order(rarity: :asc).all.map(&:rarity).uniq }

  filter :region, as: :check_boxes, collection: proc { Character.regions.keys }

  index do
    column :name
    column :region
    column :rarity
    column :description
    actions
  end
end

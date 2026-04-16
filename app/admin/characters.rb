ActiveAdmin.register Character do
  permit_params :name, :region, :rarity, :description

  filter :rarity
  filter :region, as: :select, collection: proc { Character.regions.keys }

  index do
    column :name
    column :region
    column :rarity
    column :description
    actions
  end
end

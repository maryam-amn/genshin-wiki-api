ActiveAdmin.register Character do
  permit_params :name, :region, :rarity, :description

  filter :rarity, as: :check_boxes, collection: proc { Character.order(rarity: :asc).all.map(&:rarity).uniq }

  filter :region, as: :check_boxes, collection: proc {Character.regions.keys }

  index do
    column :name
    column :region
    column :rarity
    column :description
    actions
  end
  form title: "A custom title" do |f|
    f.semantic_errors
    inputs "Details" do
      f.input :name
      f.input :region, as: :select, collection: Character.regions.keys
      f.input :rarity, as: :number, required: true
      f.input :description
    end
    actions
  end

end

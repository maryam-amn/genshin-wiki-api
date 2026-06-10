ActiveAdmin.register PlayableCharacter do
  menu false

  show do
    attributes_table do
      row :id
      row :name
      row :base_hp
      row :base_defense
      row :base_attack
      row :is_limited
      row :description
      row :region
      row :rarity
      row :created_at
    end
  end
end

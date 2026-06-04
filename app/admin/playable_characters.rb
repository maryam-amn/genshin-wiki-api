ActiveAdmin.register PlayableCharacter do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :base_attack, :base_defense, :base_hp, :is_limited
  #
  # or
  #
  # permit_params do
  #   permitted = [:base_attack, :base_defense, :base_hp, :is_limited]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
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

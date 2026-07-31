ActiveAdmin.register BossCharacter do
   menu false

   permit_params :is_weekly_boss, :location, :recommended_level

   show do
      attributes_table do
         row :id
         row :name
         row :description
         row :region
         row :rarity
         row :location do |boss|
            "#{boss.fight_region_location} - #{boss.fight_exact_location}" end
         row :is_weekly_boss
         row :recommended_level
         row :created_at
      end
   end
end

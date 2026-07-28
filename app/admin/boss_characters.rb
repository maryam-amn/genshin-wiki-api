ActiveAdmin.register BossCharacter do
   menu false

   permit_params :is_weekly_boss, :recommended_level, :exact_location, :region_location
   actions :all, except: [ :destroy, :update ]

   show do
      attributes_table do
         row :id
         row :name
         row :description
         row :region
         row :rarity
         row :location
         row :is_weekly_boss
         row :recommended_level
         row :created_at
      end
   end

   form title: I18n.t("boss_character.new.create_title") do |f|
      f.semantic_errors
      f.inputs I18n.t("boss_character.new.details_character") do
         f.input :name
         f.input :region, as: :select, collection: Character.regions.keys
         f.input :description, as: :text
         f.input :rarity, as: :number
         f.inputs I18n.t("boss_character.new.details_boss") do
            f.li "#{I18n.t("boss_character.new.location_notice")}".html_safe, style: "font-weight: 650; color: grey"
            f.input :recommended_level, as: :number
            f.input :region_location, label: "Region of the location", as: :select, collection: Character.regions.keys, required: true
            f.input :exact_location, label: "Specific localisation", as: :string, required: true
            f.input :is_weekly_boss, as: :select, include_blank: false
         end
      end
      actions
   end

   controller do
      def create
        ActiveRecord::Base.transaction do
           @boss_character = BossCharacter.create!(boss_permitted_params)
           @character = Character.create!(character_permitted_params.merge(characterable: @boss_character))
         end
         flash[:notice] = I18n.t("boss_character.new.notice")
         redirect_to admin_boss_character_path(@boss_character.id)
      rescue ActiveRecord::RecordInvalid => e
         flash[:error] = "#{I18n.t("boss_character.new.record_invalid")}, #{e} "
         redirect_to new_admin_boss_character_url
      end

      def boss_permitted_params
         params.expect(boss_character: [ :is_weekly_boss, :recommended_level, :region_location, :exact_location ])
      end
      def character_permitted_params
          params.expect([ boss_character: [ :name, :description, :rarity, :region ] ])
      end
   end
end

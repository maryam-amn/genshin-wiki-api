ActiveAdmin.register BossCharacter do
   menu false

   permit_params :is_weekly_boss, :recommended_level, :fight_region_location, :fight_exact_location
   actions :all, except: [ :destroy, :update ]

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

   form title: I18n.t("boss_characters.new.create_title") do |f|
      f.semantic_errors
      f.inputs I18n.t("boss_characters.new.details_character") do
         f.input :name
         f.input :region, as: :select, collection: Character.regions.keys
         f.input :description, as: :text
         f.input :rarity, as: :number
      end
      f.inputs I18n.t("boss_characters.new.details_boss") do
         f.input :recommended_level, as: :number
         f.li "#{I18n.t("boss_characters.new.fill_in_the_fight_location_of_a_boss")}", style: "font-weight: 650; color: grey"
         f.input :fight_region_location, as: :select, required: true, collection: BossCharacter.fight_region_locations.keys
         f.input :fight_exact_location, as: :string, required: true, label: "Specific location"
         f.input :is_weekly_boss, as: :radio
      end
      actions
   end

   controller do
      def create
        ActiveRecord::Base.transaction do
           @boss_character = BossCharacter.create!(boss_permitted_params)
           @character = Character.create!(character_permitted_params.merge(characterable: @boss_character))
         end
         flash[:notice] = I18n.t("boss_characters.new.notice")
         redirect_to admin_boss_character_path(@boss_character.id)
      rescue ActiveRecord::RecordInvalid => e
         flash[:error] = "#{I18n.t("boss_characters.new.record_invalid")}, #{e} "
         redirect_to new_admin_boss_character_url
      end

      def boss_permitted_params
         params.expect(boss_character: [ :is_weekly_boss, :recommended_level, :fight_region_location, :fight_exact_location ])
      end
      def character_permitted_params
          params.expect([ boss_character: [ :name, :description, :rarity, :region ] ])
      end
   end
end

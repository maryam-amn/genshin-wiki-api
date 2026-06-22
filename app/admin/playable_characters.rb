ActiveAdmin.register PlayableCharacter do
   permit_params :base_attack, :base_defense, :base_hp, :is_limited
   before_action :find_playable_character, only: [ :destroy, :update, :show ]

   actions :all
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

  form title: I18n.t("Playable_Characters.new")   do |f|
    f.object.errors.full_messages
    inputs "Add a new character" do
      f.li    I18n.t("Characters.new.info"), style: "font-weight: 750;"
      f.input :base_hp, required: true, label: "Base health point", style: "font-weight: 700;"
      f.input :base_defense, required: true
      f.input :base_attack, required: true
      f.input :is_limited, required: true, style: "text-align: center;"
      f.input :name, required: true
      f.input :region, as: :select, required: true, collection: Character.regions.keys, style: "width: 50%;", label: "Region"
      f.input :rarity, as: :number, required: true, placeholder: I18n.t("Characters.errors.number_between_1_5")
      f.input :description, as: :text, required: true
    end
    actions
  end

  controller do
    def create
      ActiveRecord::Base.transaction do
        @playable_character =  PlayableCharacter.create!(params.expect([ playable_character: [ :base_hp, :base_defense, :base_attack, :is_limited ] ]))
        @character = Character.create!(params.expect([ playable_character: [ :name, :description, :rarity, :region ] ]).merge(characterable: @playable_character))
      end
        flash[:notice] = I18n.t("Playable_Characters.create.notice")
        redirect_to admin_playable_character_path(@playable_character.id)
    rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = "#{I18n.t("Playable_Characters.create.record_invalid")}, #{e}"
        redirect_to new_admin_playable_character_path
    end

    def destroy
      character = @playable_character.character
      ActiveRecord::Base.transaction do
        @playable_character.destroy!
        character.destroy!
      end
      flash[:notice] = I18n.t("Playable_Characters.destroy.notice")
      redirect_to admin_characters_path
    rescue ActiveRecord::RecordNotDestroyed => e
      flash[:alert] = "  #{e}, #{character.errors[:base].to_a.join(' ')}"
      redirect_to admin_characters_path
    end

    def update
      ActiveRecord::Base.transaction do
       @playable_character.update!(params.expect([ playable_character: [ :base_hp, :base_defense, :base_attack, :is_limited ] ]))
       @playable_character.character.update!(params.expect([ playable_character: [ :name, :description, :rarity, :region ] ]))
      end
      flash[:notice] = I18n.t("Playable_Characters.update.notice")
      redirect_to admin_playable_character_path(@playable_character.id)
    rescue ActiveRecord::RecordInvalid  => e
      flash[:alert] = " #{I18n.t("Playable_Characters.update.record_invalid")}, #{e}"
      redirect_to edit_admin_playable_character_path
    end
    def find_playable_character
      @playable_character = PlayableCharacter.find(params[:id])
    end
  end
end

ActiveAdmin.register PlayableCharacter do
   permit_params :base_attack, :base_defense, :base_hp, :is_limited
   actions :all, except: [ :destroy, :update ]
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
      playable_character =  PlayableCharacter.create(params.expect([ playable_character: [ :base_hp, :base_defense, :base_attack, :is_limited ] ]))
      character = Character.create(params.expect([ playable_character: [ :name, :description, :rarity, :region ] ]).merge(characterable: playable_character))

      if character.save
        flash[:notice] = "Character successfully created"
        redirect_to admin_playable_character_path(playable_character.id)
      else
        flash[:error] =  character.errors.full_messages + playable_character.errors.full_messages
        redirect_to new_admin_playable_character_path
      end
    end
  end
end

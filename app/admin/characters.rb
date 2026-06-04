ActiveAdmin.register Character do
  permit_params :name, :region, :rarity, :description, :character_id
  before_action :find_character

  actions :all, except: [ :destroy, :update ]
  filter :rarity
  filter :region, as: :select, collection: proc { Character.regions.keys }
  filter :characterable_type, as: :select, collection: proc { Character.characterable_types }, label: "Characters Type"

    index do
      column :name
      column :region
      column :rarity
      column :description
      column :characterable_type
      actions
    end

  form title: I18n.t("Characters.new.add") do |f|
    f.object.errors.full_messages
    inputs "Add a new character" do
      f.li    I18n.t("Characters.new.info"), style: "font-weight: 750;"
      f.input :name
      f.input :region, as: :select, required: true, collection: Character.regions.keys, style: "width: 50%;", label: "Region"
      f.input :rarity, as: :number, required: true, placeholder: I18n.t("Characters.errors.number_between_1_5")
      f.input :description, as: :text, required: true
    end
    actions
    end

    controller do
      def show
        if @character.characterable_type == "PlayableCharacter"
          redirect_to admin_playable_character_path(id: @character.characterable_id)
        end
      end

      private

      def find_character
        @character = Character.find(params[:id]) if params[:id].present?
      end
    end
  end

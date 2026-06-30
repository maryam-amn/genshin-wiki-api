class Api::V1::PlayableCharactersController < ApiController
      resource_description  do
        formats [ "json" ]
      end

      before_action :find_playable_character, only: [ :show ]

      api :GET, "/api/v1/playable_characters", "list of all playable characters"
      api_version "v1"
      returns code: 200

      def index
        characters_json = PlayableCharacter.all.map { |playable_character| PlayableCharacterJson.new(playable_character:).to_h }
        render json: { playable_characters: characters_json }
      end

      api :GET, "/api/v1/playable_characters/:id", "render a playable characters"
      api_version "v1"
      returns code: 200
      error :not_found, I18n.t("Playable_Characters.errors.record_not_found")

      def show
        render json: PlayableCharacterJson.new(playable_character: @playable_character).to_h
      end

      api :POST, "/playable_characters", "create a playable character"
      api_version "v1"
      returns code: 201
      error :unprocessable_content, "a required field is missing/blank or the character's name isn't unique so the playable character can't be created"

      def create
        ActiveRecord::Base.transaction do
          @playable_character = PlayableCharacter.create!(params.permit(:base_hp, :base_defense, :base_attack, :is_limited))
          @character = Character.create!(params.permit(:name, :description, :rarity, :region).merge(characterable: @playable_character))
        end
        render json: PlayableCharacterJson.new(playable_character: @playable_character).to_h, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render status: :unprocessable_entity, json: { error: I18n.t("Playable_Characters.create.record_invalid"), details: { field: [ e.message ] } }
      end

      def find_playable_character
        @playable_character = PlayableCharacter.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render status: :not_found, json: { error:  I18n.t("Playable_Characters.errors.record_not_found"), details: { field: [ e ] } }
      end
end

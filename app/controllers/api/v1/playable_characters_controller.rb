class Api::V1::PlayableCharactersController < ApiController
      resource_description  do
        formats [ "json" ]
      end

      before_action :find_playable_character, only: [ :show, :destroy, :update ]

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
      error :not_found, I18n.t("playable_characters.errors.record_not_found")

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
        render status: :unprocessable_entity, json: { error: I18n.t("playable_characters.create.record_invalid"), details: { field: [ e.message ] } }
      end


      api :DELETE, "/playable_characters/:id", "delete a playable character"
      api_version "v1"
      returns code: 200
      error :unprocessable_content, "can't destroy a playable character who's a legendary one"
      error :not_found, I18n.t("playable_characters.errors.record_not_found")

      def destroy
        ActiveRecord::Base.transaction do
          @playable_character.character.destroy!
        end
        render json: { message: I18n.t("playable_characters.destroy.notice") }, status: :ok
      rescue ActiveRecord::RecordNotDestroyed => e
        render status: :unprocessable_entity, json: { error: I18n.t("playable_characters.errors.record_not_destroyed"), details: { field: [ @playable_character.character.errors[:base].to_a.join(" "), e.message ] } }
      end

      api :PUT, "/playable_characters/:id", "Update a resource (full replacement)"
      api :PATCH, "/playable_characters/:id", "update some playable character's fields"
      api_version "v1"
      returns code: 200
      error :unprocessable_content, "can't update a playable character who doesn't follow the model's validation"
      error :not_found, I18n.t("playable_characters.errors.record_not_found")

      def update
        @playable_character.assign_attributes(playable_character_params)
        @playable_character.character.assign_attributes(character_params)
        if @playable_character.changed? || @playable_character.character.changed?
          ActiveRecord::Base.transaction do
            @playable_character.save!
            @playable_character.character.save!
          end
        end
        render json: PlayableCharacterJson.new(playable_character: @playable_character).to_h, status: :ok
      rescue ActiveRecord::RecordInvalid=> e
        render status: :unprocessable_entity, json: { error: I18n.t("playable_characters.update.record_invalid"), details: { field: [ e.message ] } }
      end

      def find_playable_character
        @playable_character = PlayableCharacter.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render status: :not_found, json: { error:  I18n.t("playable_characters.errors.record_not_found"), details: { field: [ e ] } }
      end

      def playable_character_params
        params.permit([ :base_hp, :base_defense, :base_attack, :is_limited ])
      end
      def character_params
        params.permit([ :name, :description, :rarity, :region  ])
      end
end

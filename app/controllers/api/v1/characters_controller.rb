class Api::V1::CharactersController < ApiController
      resource_description  do
        formats [ "json" ]
      end

      api :GET, "/characters", "list of all characters"
      api_version "v1"
      returns code: 200

      param :region, [ "Liyue", "Fontaine", "Montstadt" ], desc: "Filter to show all characters from a region"
      param :rarity, :number, between: [ 1...5 ], desc: "Filter to show all characters of a rarity"
      param :characterable_type, [ "PlayableCharacter" ], desc: "Filter to get all character by type of character"

      def index
        conditions = permitted_params_to_filter.slice(:region, :rarity, :characterable_type).to_h.compact
        characters = Character.where(conditions)
        characters_json = characters.map { |character| CharacterJson.new(character:).to_h }
        render json: { characters: characters_json }, status: :ok
   end

      api :GET, "/characters/:id", "render a character"
      api_version "v1"
      returns code: 200
      error :not_found, "character not found"
      def show
        begin
          character = Character.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render status: :not_found, json: { message: "Character not found" }
        else
          render json: CharacterJson.new(character:).to_h
        end
      end

      api :POST, "/characters", "create a character"
      api_version "v1"
      returns code: 201
      error :unprocessable_content, "a required field is missing/blank or the character's name isn't unique so the character cannot be created "

      def create
        character = Character.new(params.expect(character: [ :name, :description, :rarity, :region ]))

        if character.save
          render json: CharacterJson.new(character:).to_h, status: :created
        else
          render json: character.errors, status: :unprocessable_content
        end
      end

      api :DELETE, "/characters/:id", "delete a character"
      api_version "v1"
      returns code: 200
      error :not_found, "character not found"
      error :unprocessable_content, "legendary character shouldn't be deleted"

      def destroy
        character = Character.find(params[:id])
        if character.destroy
          render json: { message: "Character deleted" }, status: :ok
        else
          render json: { message: "Character can not be deleted, #{character.errors[:base].to_a.join(' ')}" }, status: :unprocessable_content
        end
      rescue ActiveRecord::RecordNotFound
        render json: { message: "Character not found" }, status: :not_found
      end

      api :PUT, "/characters/:id", "Update a resource (full replacement)"
      api :PATCH, "/characters/:id", "update some character's fields"
      api_version "v1"
      returns code: 200
      param :id, :number, desc: "Character ID", required: true
      error :not_found, "character not found"
      error :unprocessable_content, "can't update a character who doesn't follow the model's validation"

      def update
        character = Character.find(params.permit(:id)[:id])
        if character.update(params.permit(:name, :description, :rarity, :region))
          render json: CharacterJson.new(character:).to_h, status: :ok
        else
          render json: { message: "Character can not be deleted, #{character.errors.to_a.join(', ')}" }, status: :unprocessable_content
        end
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { message: "Character not found" }
      end
      def permitted_params_to_filter
        params.permit(:region, :rarity, :characterable_type)
      end
end

class Api::V1::CharactersController < ApiController
      api :GET, "/characters", "list of all characters"
      api_version "v1"
      returns code: 200
      def index
        characters_json = Character.all.map { |character| CharacterJson.new(character:).to_h }
        render json: { characters: characters_json }
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
      error :unprocessable_entity, "a required field is missing/blank or the character's name isn't unique so the character cannot be created "

      def create

        character = Character.new(params.expect(character:[:name, :description, :rarity, :region]))

        if character.save
          render json: CharacterJson.new(character:).to_h, status: :created
        else
          render json: character.errors, status: :unprocessable_entity
        end
      end
end

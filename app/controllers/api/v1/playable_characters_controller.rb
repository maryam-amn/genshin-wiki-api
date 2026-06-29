class Api::V1::PlayableCharactersController < ApiController
      resource_description  do
        formats [ "json" ]
      end

      api :GET, "/api/v1/playable_characters", "list of all playable characters"
      api_version "v1"
      returns code: 200
      def index
        characters_json = PlayableCharacter.all.map { |playable_character| PlayableCharacterJson.new(playable_character:).to_h }
        render json: { playable_characters: characters_json }
      end
end

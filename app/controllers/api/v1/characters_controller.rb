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
      param :page, :number, greater_than: 0, desc: "Define the page where the elements are located"
      param :per_page, :number, greater_than: 0, desc: "Set the number of items per page"

      def index
        conditions = permitted_params_to_filter.slice(:region, :rarity, :characterable_type).to_h.compact
        characters = Character.where(conditions)
        characters_per_page = characters.page(permitted_params_to_filter[:page]).per(permitted_params_to_filter[:per_page])
        characters_json = characters_per_page.map { |character| CharacterJson.new(character:).to_h }

        render json: {
          characters: characters_json,
          pagination: {
            next_page: characters_per_page.next_page,
            total_page: characters_per_page.total_pages,
            current_page: characters_per_page.current_page
          }
        }, status: :ok
      end

      def permitted_params_to_filter
        params.permit(:region, :rarity, :characterable_type, :page, :per_page)
      end
end

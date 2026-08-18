class Api::V1::BossCharactersController < ApiController
  resource_description  do
    formats [ "json" ]
  end

  api :GET, "api/v1/boss_characters", "list all boss characters"
  api_version "v1"
  returns code: 200

  def index
    boss_character = BossCharacter.all.map { |boss_character| BossCharacterJson.new(boss_character:).to_h }
    render json: { boss_characters: boss_character }, status: 200
  end
end

class Api::V1::BossCharactersController < ApiController
  resource_description  do
    formats [ "json" ]
  end

  before_action :find_boss_character, only: [ :show ]

  api :GET, "api/v1/boss_characters", "list all boss characters"
  api_version "v1"
  returns code: 200

  def index
    boss_characters = BossCharacter.all.map { |boss_character| BossCharacterJson.new(boss_character:).to_h }
    render json: { boss_characters: boss_characters }, status: 200
  end

  api :GET, "api/v1/boss_characters/:id", "show an boss character"
  api_version "v1"
  returns code: 200
  error :not_found, I18n.t("boss_characters.active_record_error.record_not_found")

  def show
    render json: BossCharacterJson.new(boss_character: @boss_character).to_h, status: 200
  end

  api :POST, "api/v1/boss_characters", "create boss character"
  api_version "v1"
  returns code: 200
  error :unprocessable_entity, "can't create a boss character who doesn't follow the model's validation"

  def create
    ActiveRecord::Base.transaction do
      @boss_character = BossCharacter.create!(boss_character_params)
      @character = Character.create!(character_params.merge(characterable: @boss_character))
    end
    render json: BossCharacterJson.new(boss_character: @boss_character).to_h, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render status: :unprocessable_entity, json: { error: I18n.t("boss_characters.new.record_invalid"), details: { field: [ e.message ] } }
  end

  def find_boss_character
    @boss_character = BossCharacter.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found, json: { error: I18n.t("boss_characters.active_record_error.record_not_found"), details: { field: [ e ] } }
  end

  def boss_character_params
    params.permit(:is_weekly_boss, :recommended_level, :fight_region_location, :fight_exact_location)
  end

  def character_params
    params.permit(:name, :description, :rarity, :region)
  end
end

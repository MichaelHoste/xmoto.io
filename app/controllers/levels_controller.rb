class LevelsController < ApplicationController
  def show
    @level = Level.find_by_level_identifier(params[:id])

    if current_user
      @best_score = @level.level_user_links.find_by_user_id(current_user.id)
    end
  end

  def index
    incompatible_levels = [15]
    incompatible_levels.collect! { |level_file_id| "l#{level_file_id}.lvl" }

    @levels                = Level.where.not(:file_name => incompatible_levels)
    @levels_with_score_ids = current_user ? current_user.level_user_links.pluck(:level_id) : []
  end
end

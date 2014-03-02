class LevelsController < ApplicationController
  def show
    @level = Level.find_by_level_identifier(params[:id])

    if current_user
      @best_score = @level.level_user_links.find_by_user_id(current_user.id)
    end
  end

  def index
    @levels = Level.all
  end
end

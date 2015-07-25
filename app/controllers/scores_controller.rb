class ScoresController < ApplicationController
  # Post new score with level_identifier and user from session
  def create
    @level = Level.find_by_level_identifier(params[:level])
    @score = @level.scores.find_by_user_id(current_user.id)

    new_values = {
      :time   => params[:time].to_i,
      :steps  => params[:steps].to_i,
      :replay => params[:replay]
    }

    if @score.present? && params[:steps].to_i < @score.steps
      @score.update_attributes(new_values)
      saved = true
    elsif @score.blank?
      @score = @level.scores.create!(new_values.merge!({
        :user_id  => current_user.id
      }))
      saved = true
    end

    if saved
      begin
        Pusher.trigger(@level.level_identifier, 'new_score', @score)
      rescue Pusher::Error => e
        Rails.logger.info("PUSHER ERROR : #{e}") # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
      end

      render :json => { :success => true,  :score_id => @score.id }
    else
      render :json => { :success => false, :error   => 'not saved (not better score or something went wrong)' }
    end
  end

  # Get JSON with all scores from a level
  def index
    @level  = Level.find_by_level_identifier(params[:level_id])
    @scores = @level.scores.order('steps ASC')
    render :json => @scores
  end
end

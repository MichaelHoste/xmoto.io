class LevelUserLinksController < ApplicationController
  # Post new score with level_identifier and user from session
  def create
    @level = Level.find_by_level_identifier(params[:level])
    @score = @level.level_user_links.find_by_user_id(current_user.id)

    new_values = { :time  => params[:time].to_i,
                   :steps => params[:steps].to_i,
                   :fps   => params[:fps].to_i }

    if @score.present? && params[:steps].to_i < @score.steps
      @score.update_attributes(new_values)
      save_file = true
    elsif @score.blank?
      @score = LevelUserLink.create!(new_values.merge!({ :user_id => current_user.id,
                                                         :level_id => @level.id }))
      save_file = true
    else
      save_file = false
    end

    if save_file
      File.open("public/data/Replays/#{@score.id}.replay", 'w') do |f|
        f.write(params[:replay])
      end

      begin
        Pusher.trigger(@level.level_identifier, 'new_score', @score)
      rescue Pusher::Error => e
        Rails.logger.info("PUSHER ERROR : #{e}") # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
      end

      render :json => { :success  => true,
                        :score_id => @score.id }
    else
      render :json => { :success => false,
                        :error   => 'not saved (not better score or something went wrong)' }
    end
  end

  # Get JSON with all scores from a level
  def index
    @level  = Level.find_by_level_identifier(params[:level])
    @scores = @level.level_user_links.order('steps ASC')
    render :json => @scores
  end
end



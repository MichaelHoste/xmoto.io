class LevelsController < ApplicationController
  def show
    @level = Level.find_by_level_identifier(params[:id])
  end

  def index
    #@levels_with_score_ids = current_user ? current_user.scores.pluck(:level_id) : []

    files = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 27, 980, 1010, 1038, 1040, 1041, 1042, 1043, 1044].collect { |num| "l#{num}.lvl" }
    @levels = Level.where(:file_name => files)
  end

  def capture
    @level = Level.find_by_level_identifier(params[:id])

    image = Base64.decode64(params[:image]['data:image/png;base64,'.length .. -1])
    File.open("tmp/#{@level.level_identifier}.png", 'wb') do |file|
      file.write(image)
    end

    @level.preview = File.open("tmp/#{@level.level_identifier}.png")
    @level.save!

    render :nothing => true
  end
end

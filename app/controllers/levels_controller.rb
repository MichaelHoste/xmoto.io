class LevelsController < ApplicationController
  def show
    @level = Level.find(params[:id])
  end

  def index
    @levels = Level.all
  end
end

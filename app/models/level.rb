# encoding: utf-8

class Level < ActiveRecord::Base

  mount_uploader :preview, PreviewUploader

  # Constants

  # Attributes

  # Associations

  has_many :scores

  # Validations

  validates :level_identifier, :uniqueness => true

  # Callbacks

  # Scopes

  # Class Methods

  # Methods

  def best_score(user_id = nil)
    scores.where.not(:user_id => user_id).order('steps ASC').try(:first)
  end

  def to_param
    level_identifier
  end
end

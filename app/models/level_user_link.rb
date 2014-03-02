class LevelUserLink < ActiveRecord::Base
  # Constants

  # Attributes

  # Associations

  belongs_to :level
  belongs_to :user

  # Nested attributes

  # Validations

  # user_id can be null for anonymous scores
  validates :level_id, :time, :steps, :fps,
            :presence => true

  # Callbacks

  # Scopes

  # Class Methods

  # Methods
end

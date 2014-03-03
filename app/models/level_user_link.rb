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

  def as_json(options = {})
    { :id           => id,
      :user_id      => user.id,
      :user_name    => user.name,
      :user_picture => user.profile_picture,
      :user_link    => user.f_link,
      :steps        => steps,
      :fps          => fps,
      :updated_at   => updated_at }
  end
end

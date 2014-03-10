# encoding: utf-8

class Level < ActiveRecord::Base

  mount_uploader :preview, PreviewUploader

  # Constants

  # Attributes

  # Associations

  has_many :level_user_links

  # Validations

  validates :level_identifier, :uniqueness => true

  # Callbacks

  # Scopes

  # Class Methods

  # Methods

  def to_param
     level_identifier
   end
end

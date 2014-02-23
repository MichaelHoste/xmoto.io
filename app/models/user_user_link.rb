class UserUserLink < ActiveRecord::Base

  # Constants

  # Attributes

  # Associations
  belongs_to :user,
             :class_name  => 'User',
             :primary_key => 'f_id'

  belongs_to :friend,
             :class_name  => 'User',
             :primary_key => 'f_id'

  # Nested attributes

  # Validations

  validates_uniqueness_of :user_id, :scope => :friend_id

  # Callbacks

  # Class methods
end

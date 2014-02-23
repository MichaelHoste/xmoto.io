require 'net/https'

class User < ActiveRecord::Base
  # Constants

  DAYS_BEFORE_UPDATING_FRIENDS = 5

  # Attributes

  # Associations

  # Associations
  has_many :user_user_links,
           :primary_key => :f_id

  has_many :friends,
           :through => :user_user_links

  # Nested attributes

  # Validations
  validates :f_id, :uniqueness => true

  # Callbacks

  # Scopes

  def self.registered
    where('email IS NOT NULL')
  end

  def self.not_registered
    where('email IS NULL')
  end

  # Methods

  def self.from_omniauth(auth)
    User.where(:provider => 'facebook', :f_id => auth.uid).first_or_initialize.tap do |user|
      user.provider       = auth.provider
      user.f_id           = auth.uid
      user.name           = auth.info.name
      user.email          = auth.info.email
      user.gender         = auth.extra.raw_info.gender
      user.locale         = auth.extra.raw_info.locale
      user.picture        = auth.info.image
      user.f_token        = auth.credentials.token
      user.f_expires      = auth.credentials.expires
      user.f_expires_at   = Time.at(auth.credentials.expires_at)
      user.f_first_name   = auth.info.first_name
      user.f_middle_name  = auth.info.middle_name
      user.f_last_name    = auth.info.last_name
      user.f_username     = auth.extra.raw_info.username
      user.f_link         = auth.extra.raw_info.link
      user.f_location     = auth.extra.raw_info.location.name
      user.f_location_id  = auth.extra.raw_info.location.id
      user.f_timezone     = auth.extra.raw_info.timezone
      user.f_updated_time = auth.extra.raw_info.updated_time
      user.f_verified     = auth.extra.raw_info.verified

      if user.new_record?
        # Facebook bug : sometimes the email is empty (only on Sokoban-game ?)
        user.email         = "#{user.f_username}@facebook.com" if not user.email or user.email.empty?
        user.registered_at = Time.now
      end

      user.save!

      if user.friends_updated_at
        user.delay.update_friendships
      else
        user.update_friendships
      end
    end
  end

  def has_to_update_friendships?
    if not self.friends_updated_at
      true
    elsif Time.now.to_date - self.friends_updated_at.to_date > DAYS_BEFORE_UPDATING_FRIENDS
      true
    else
      false
    end
  end

  # create new user for each friend and link it
  def update_friendships
    if has_to_update_friendships?
      graph = Koala::Facebook::API.new(self.f_token)
      friends = graph.get_connections('me', 'friends')

      # update users and user_user_link relation
      friends.each do |friend|
        Rails.logger.info(friend.inspect)

        user = User.find_or_create_by_f_id(friend['id'])
        user.update_attributes!({ :name => friend['name'] })
        self.user_user_links.find_or_create_by_user_id_and_friend_id(self.f_id, user.f_id)
      end

      # delete user_user_link is not facebook friend anymore
      friend_ids = friends.collect{ |friend| friend['id'] }
      self.user_user_links.where('user_user_links.friend_id not in (?)', friend_ids).destroy_all

      self.update_attributes!({ :friends_updated_at => Time.now })
    end
  end

  def registered?
    self.email != nil
  end

  def admin?
    self.f_id == ENV['FACEBOOK_ADMIN_ID'].to_i
  end

  def profile_picture(size = "square")
    arg = (size.is_a? Integer) ? "width=#{size}" : "type=#{size}"
    "https://graph.facebook.com/#{self.f_id}/picture?#{arg}"
  end
end

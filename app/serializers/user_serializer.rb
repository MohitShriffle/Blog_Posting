# frozen_string_literal: true

# UserSerializer class
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_name, :email, :profile_picture_url

  def profile_picture_url
    object.profile_picture.url
  end
end

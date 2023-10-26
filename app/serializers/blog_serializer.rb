# frozen_string_literal: true

# class BlogSerializer
class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id
end

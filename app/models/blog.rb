# frozen_string_literal: true

# blog class
class Blog < ApplicationRecord
  belongs_to :user
  validates :title, :body, presence: true

  def increment_modification_count
    self.update(modifications_count: modifications_count + 1 )    
  end

end

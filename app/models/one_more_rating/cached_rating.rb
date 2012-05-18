module OneMoreRating
  class CachedRating < ActiveRecord::Base
    belongs_to :rateable, :polymorphic => true
  end
end
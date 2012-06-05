class FixIndexOnRatings < ActiveRecord::Migration
  def up
    remove_index :one_more_rating_ratings, :name => "main_index"
    add_index :one_more_rating_ratings, [:rateable_type, :rateable_id, :scope, :user_id], {:name => "main_index", :unique => true}
  end

  def down
    remove_index :one_more_rating_ratings, :name => "main_index"
    add_index :one_more_rating_ratings, [:rateable_type, :rateable_id, :scope], {:name => "main_index", :unique => true}
  end
end

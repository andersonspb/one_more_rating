class CreateCachedRatings < ActiveRecord::Migration
  def up
    create_table :one_more_rating_cached_ratings do |t|
      t.column :score, :decimal, :precision => 10, :scale => 2
      t.column :score1, :decimal, :precision => 10, :scale => 2
      t.column :score2, :decimal, :precision => 10, :scale => 2
      t.column :score3, :decimal, :precision => 10, :scale => 2
      t.column :score4, :decimal, :precision => 10, :scale => 2
      t.column :score5, :decimal, :precision => 10, :scale => 2
      t.column :scope, :integer
      t.column :rateable_id, :integer
      t.column :rateable_type, :string, :limit => 32
      t.timestamps
    end
    add_index :one_more_rating_cached_ratings, [:rateable_type, :rateable_id, :scope], {:name => "main_index", :unique => true}
  end

  def down
    drop_table :one_more_rating_cached_ratings
  end
end

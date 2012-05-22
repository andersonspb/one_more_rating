module OneMoreRating
  class RatingsController < ApplicationController
    def create
      @rateable = Object.const_get(params[:rateable_type]).find(params[:rateable_id])
      @rateable.rate(params[:score], current_user.id, params[:rateable_scope])

      respond_to do |format|
        #format.js
        format.json { render :json => @rateable.rating_score(params[:rateable_scope]) }
      end
    end
  end
end
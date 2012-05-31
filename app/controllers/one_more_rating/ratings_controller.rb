module OneMoreRating
  class RatingsController < ApplicationController
    def create
      @rateable = Object.const_get(params[:rateable_type]).find(params[:rateable_id])
      scope = @rateable.class.rateable_scope.call
      @rateable.rate(params[:score], current_user.id, scope)

      respond_to do |format|
        #format.js
        format.json { render :json => @rateable.rating_score(scope) }
      end
    end
  end
end
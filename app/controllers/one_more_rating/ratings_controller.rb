module OneMoreRating
  class RatingsController < ApplicationController
    def create
      rateable_type = Object.const_get(params[:rateable_type])
      @rateable = rateable_type.find(params[:rateable_id])

      raise SecurityError.new("An attempt to rate an object of type that is not rateable") if !@rateable.respond_to?(:rate)

      scope = @rateable.class.rateable_scope.call
      @rateable.rate(params[:score], current_user.id, scope)

      respond_to do |format|
        #format.js
        format.json { render :json => @rateable.rating_score(scope) }
      end
    end
  end
end
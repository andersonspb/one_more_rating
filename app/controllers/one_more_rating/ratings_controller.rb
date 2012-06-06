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


        format.json {
          score = {}
          votes = {}
          @rateable.class.periods.keys.each do |period_name|
            score[period_name] =  @rateable.rating_score(scope, period_name)
            votes[period_name] =  @rateable.count_votes(scope, period_name)
          end
          score[:total] =  @rateable.rating_score(scope)
          votes[:total] =  @rateable.count_votes(scope)

          render :json => {:score => score, :votes => votes}
        }
      end
    end
  end
end
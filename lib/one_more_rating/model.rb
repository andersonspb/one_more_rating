module OneMoreRating

  module Model

    def self.included(base)
      @periods = nil
      @statistics_method = nil
      @rateable_scope = nil
      @bayesian_votes_minimum = nil
      @bayesian_average = nil
    end

    module InstanceMethods
      def rate(score, user_id, scope)

        rating = Rating.where(['rateable_type = ? and rateable_id = ? and scope = ? and user_id = ?',
                                               self.class.name, self.id, scope, user_id]).first||
            self.ratings2.build(:user_id => user_id, :scope => scope)
        rating.score = score
        rating.save!
        update_cache(scope)

        return(rating)
      end

      def rating_score(scope, period_name = nil)
        period_no = period_name ? period_no_by_name(period_name) : ""
        score_attr = "score#{period_no}"

        if !scope.nil?
          return find_cached_rating(scope).try(score_attr) || 0
        else
          # No scope given. Count average by all scopes
          self.cached_ratings.map{|cache| cache.try(score_attr)}.inject{ |sum, score| sum + score }.to_f / self.cached_ratings.count
        end
      end

      def count_votes(scope, period_name = nil)
        conditions = build_conditions(scope, period_name)
        return Rating.count(:conditions => conditions)
      end

      private

      def period_no_by_name(period_name)
        self.class.periods.keys.index(period_name) + 1
      end

      def period_value_by_name(period_name)
        self.class.periods[period_name]
      end

      def find_cached_rating(scope)
        CachedRating.where(['rateable_type = ? and rateable_id = ? and scope = ?',
                                           self.class.name, self.id, scope]).first
      end

      def update_cache(scope)
        cached = find_cached_rating(scope) ||
            self.cached_ratings.build(:scope => scope)
        cached.score = calc_statistics(scope)
          self.class.periods.keys.each_with_index do |period_name, index|
          cached.send("score#{index + 1}=", calc_statistics(scope, period_name))
        end
        cached.save!
      end

      def build_conditions(scope, period_name = nil)
        conditions = ["rateable_type = ? and rateable_id = ? and scope = ?", self.class.name, self.id, scope]
        if period_name
          conditions[0] += " and created_at > ?"
          conditions << period_started_at(period_name)
        end
        return conditions
      end

      def calc_statistics(scope, period_name = nil)
        return send("calc_statistics_by_#{self.class.statistics_method.to_s}", scope, period_name)
      end

      def calc_statistics_by_average(scope, period_name = nil)
        conditions = build_conditions(scope, period_name)
        return Rating.average("score", :conditions => conditions)
      end

      def calc_statistics_by_bayesian(scope, period_name = nil)
        votes = count_votes(scope, period_name).to_f
        average = calc_statistics_by_average(scope, period_name)
        return  votes/(votes + self.class.bayesian_votes_minimum)*average + self.class.bayesian_votes_minimum/(votes + self.class.bayesian_votes_minimum)*self.class.bayesian_average
      end

      def period_started_at(period_name)
        return Time.now - period_value_by_name(period_name)
      end
    end

    module ClassMethods
      def periods
        @periods
      end

      def statistics_method
        @statistics_method
      end

      def rateable_scope
        @rateable_scope
      end

      def bayesian_votes_minimum
        @bayesian_votes_minimum
      end

      def bayesian_average
        @bayesian_average
      end

    end
  end

  module ModelExtender

    AVERAGE_CONST = 3.5
    VOTES_MINIMUM = 30.0

    def rateable(options)
      has_many :ratings2, :class_name => "OneMoreRating::Rating",  :as => :rateable, :dependent => :destroy
      has_many :cached_ratings, :class_name => "OneMoreRating::CachedRating",  :as => :rateable, :dependent => :destroy

      include OneMoreRating::Model::InstanceMethods
      extend  OneMoreRating::Model::ClassMethods

      @periods = options[:periods]||{}
      @statistics_method = options[:statistics_method] || "average"
      @rateable_scope = options[:scope]

      options[:bayesian] ||= {}
      @bayesian_votes_minimum = options[:bayesian][:votes_minimum] || VOTES_MINIMUM
      @bayesian_average = options[:bayesian][:average] || AVERAGE_CONST
    end
  end
end

ActiveRecord::Base.send(:extend, OneMoreRating::ModelExtender)

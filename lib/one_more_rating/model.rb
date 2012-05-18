module OneMoreRating

  module Model

    def self.included(base)
      @periods = nil
      @statistics_method = nil
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

        return find_cached_rating(scope).try("score#{period_no}") || 0
      end

      def count_votes(scope, starting_at = nil)
        conditions = build_conditions(scope, starting_at)

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
          self.class.periods.keys.each_with_index do |key, index|
          cached.send("score#{index + 1}=", calc_statistics(scope, Time.now - period_value_by_name(key)))
        end
        cached.save!
      end

      def build_conditions(scope, starting_at)
        conditions = ["rateable_type = ? and rateable_id = ? and scope = ?",
                      self.class.name, self.id, scope]

        if starting_at
          conditions[0] += " and created_at > ?"
          conditions << starting_at
        end

        return conditions
      end

      def calc_statistics(scope, starting_at = nil)
        return send("calc_statistics_by_#{self.class.statistics_method.to_s}", scope, starting_at)
      end

      def calc_statistics_by_average(scope, starting_at = nil)

        conditions = build_conditions(scope, starting_at)

        return Rating.average("score", :conditions => conditions)
      end

      AVERAGE_CONST = 7.2453
      VOTES_MINIMUM = 30.0

      def calc_statistics_by_bayesian(scope, starting_at = nil)
        conditions = build_conditions(scope, starting_at)
        votes = count_votes(scope, starting_at).to_f
        average = Rating.average("score", :conditions => conditions)

        return  votes/(votes + VOTES_MINIMUM)*average + VOTES_MINIMUM/(votes + VOTES_MINIMUM)*AVERAGE_CONST
      end
    end

    module ClassMethods
      def periods
        @periods
      end

      def statistics_method
        @statistics_method
      end
    end
  end

  module ModelExtender

    def rateable(options)
      has_many :ratings2, :class_name => "OneMoreRating::Rating",  :as => :rateable, :dependent => :destroy
      has_many :cached_ratings, :class_name => "OneMoreRating::CachedRating",  :as => :rateable, :dependent => :destroy

      include OneMoreRating::Model::InstanceMethods
      extend  OneMoreRating::Model::ClassMethods

      @periods = options[:periods]||{}
      @statistics_method = options[:statistics_method] || "average"

    end
  end
end

ActiveRecord::Base.send(:extend, OneMoreRating::ModelExtender)

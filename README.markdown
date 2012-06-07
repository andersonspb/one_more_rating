OneMoreRating
===

This is a one more star rating plugin.

Features
---

* Keeps aggregated statistics of ratings for arbitrary time periods. Week, 3 weeks, month etc (Up to 5 periods)
* Scoped ratings supported on rateable objects
* 2 algorithms of rating value calculating
* Rails 3 support
* Everything is packed as a Rails Engine
* Minimal HTML code usage (Thanks to [Rateit jQuery plugin](http://rateit.codeplex.com/))
* Unobtrusive JavaScript approach

Installation & Usage
---

1. Add dependency to your Gemfile:

    gem 'one_more_rating', :git => 'git://github.com/andersonspb/one_more_rating.git'

2. Add nested resource `ratings` for resource you want to be rated:

    resources :articles do
      resource :ratings, :only => [:create], :module => 'one_more_rating', :rateable => 'broadcast'
    end

3. Install migrations:

    $ rake one_more_rating:install:migrations

4. Execute migrations:

    $ rake db:migrate

5. Include call of `rateable` method to class your are going to rate:

    class MyRateable < ActiveRecord::Base
      rateable :scope => Proc.new {user.country_id}
    end

Parameters:
<i>scope</i> - The scope (an integer) the rating will be counted in.

Optionally. Your can pass the following parameters to "rateable" call:

<i>periods</i> - a hash on periods you want to aggregate rating statistics for. Important! Do not modify the order of periods in the value of the parameter after the system in production (But you can safely add more periods to the end of the list in any moment. 5 periods in total). The plugin references actual positions of the periods in the list for mapping between the periods and corresponding database table columns. So do not mess it up!

<i>statistics_method</i> - The parameter defines the algorithm to use to calculate aggregated value of the rating on given rateable class.  Accepts one the the following values: "average" (default value) and "bayesian" (more smart algorithm).


Example

<pre>
class Article < ActiveRecord::Base
  rateable :periods => {:week => 1.week, :month => 1.month, :month3 => 3.months},
  :statistics_method => :bayesian, :bayesian => {:votes_minimum => 10, :average = > 3}
end
</pre>

6. Call `rating_for` helper method in your template

<pre>
rating_for(@article)
</pre>

Parameters:
<i>First parameter</i> - the object to rate (And show rating for)

Optional parameters:

<i>url</i> - the path to the controller called to rate the object. By default, the engine controller implementation will be used.

<i>period</i> - the period the rating value will be show for.

<i>readonly - true/false</i> - Dose not allow users modify the rating.

<i>min</i> Minimal rating value. 0 by default.

<i>max</i> Maximum rating value. 5 by default.

<i>step</i> Step of user rating value change. 1 by default. You can put decimal value 0.5 etc


Example:

    rating_for(@article, :url => article_ratings_path(@article), :period => :week)

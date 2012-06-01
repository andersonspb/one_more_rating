module OneMoreRating
  module ApplicationHelper

    def rating_for(rateable, options = {})
      rateit_options = {}
      rateit_options["class"] ||= "rateit"
      rateit_options["data-rateit-resetable"] = options[:resetable] || false
      rateit_options["data-rateit-ispreset"] = options[:ispreset] || true
      rateit_options["data-rateit-min"] = options[:min] || 0
      rateit_options["data-rateit-max"]  = options[:max] || 5
      rateit_options["data-rateit-step"]  = options[:step] || 1
      rateit_options["data-rateit-value"]  = options[:value] || rateable.rating_score(rateable.class.rateable_scope.call, options[:period])
      rateit_options["data-rateable_id"]  = rateable.id
      rateit_options["data-rateable_type"]  = rateable.class.name
      rateit_options["id"]  = options[:id] || "rateable_#{rateable.class.name.downcase}_#{rateable.id}"
      rateit_options["data-url"]  = options[:url] || "/one_more_rating/ratings"
      rateit_options["data-rateit-readonly"]  = options[:readonly] || false

      content_tag(:div, nil, rateit_options)
    end
  end
end
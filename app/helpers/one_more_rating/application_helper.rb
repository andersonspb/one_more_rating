module OneMoreRating
  module ApplicationHelper

    def rating_for(rateable, options = {})
      rateit_options = {}
      rateit_options["class"] ||= "rateit"
      rateit_options["data-rateitResetable"] = options[:resetable] || false
      rateit_options["data-rateitIspreset"] = options[:ispreset] || true
      rateit_options["data-rateitMin"] = options[:min] || 0
      rateit_options["data-rateitMax"]  = options[:max] || 10
      rateit_options["data-rateitValue"]  = options[:value] || rateable.rating_score(options[:scope], options[:period])
      rateit_options["data-rateable_id"]  = rateable.id
      rateit_options["data-rateable_type"]  = rateable.class.name
      rateit_options["data-rateable_scope"] = options[:scope]
      rateit_options["id"]  = options[:id] || "rateable_#{rateable.class.name}_#{rateable.id}"
      rateit_options["data-url"]  = options[:url] || "/one_more_rating/ratings"

      content_tag(:div, nil, rateit_options)
    end
  end
end
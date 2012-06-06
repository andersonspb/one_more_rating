module OneMoreRating
  module ApplicationHelper

    def rating_for(rateable, options = {})
      attrs = {}
      attrs["class"] ||= "rateit"
      attrs["data-rateit-resetable"] = options[:resetable] || false
      attrs["data-rateit-ispreset"] = options[:ispreset] || true
      attrs["data-rateit-min"] = options[:min] || 0
      attrs["data-rateit-max"]  = options[:max] || 5
      attrs["data-rateit-step"]  = options[:step] || 1
      attrs["data-rateit-value"]  = options[:value] || rateable.rating_score(rateable.class.rateable_scope.call, options[:period])
      attrs["data-rateable_id"]  = rateable.id
      attrs["data-rateable_type"]  = rateable.class.name
      attrs["id"]  = options[:id] || "rateable_#{rateable.class.name.downcase}_#{rateable.id}"
      attrs["data-url"]  = options[:url] || "/one_more_rating/ratings"
      attrs["data-rateit-readonly"]  = options[:readonly] || false
      if options[:period]
        attrs["data-period"] = options[:period]
      end
      content_tag(:div, nil, attrs)
    end
  end
end
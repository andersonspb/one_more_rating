module OneMoreRating
  class Engine < ::Rails::Engine
    isolate_namespace OneMoreRating

    # Не помогает ...
    #config.asset_path = "/one_more_rating/%s"

    config.to_prepare do
      ApplicationController.helper(OneMoreRating::ApplicationHelper)
    end

  end
end

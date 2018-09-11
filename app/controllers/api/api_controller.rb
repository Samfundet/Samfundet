module Api
  class APIController < ActionController::API
    before_action :snakecase_params!
    after_action :allow_cors

    def allow_cors
      response.set_header('Access-Control-Allow-Origin', '*')
    end

    def snakecase_params!
      params.deep_transform_keys!(&:underscore)
    end

    def paginate(elements, page, pagesize = 10)
      elements
        .order(created_at: :desc)
        .limit(pagesize)
        .offset(page * pagesize)
    end
  end
end

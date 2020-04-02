class ApplicationController < ActionController::API
    def custom_render(code, body)
        render json: {
            "error": {
                "code": code,
                "body": body
            }
        } and return
    end
end

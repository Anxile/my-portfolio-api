class ApplicationController < ActionController::API
    include Devise::Controllers::Helpers
    include RackSessionFix

    def now_user
        current_user
    end
    private
    def is_superuser?
        UserSerializer.new(current_user).serializable_hash[:data][:attributes][:'email'] == "chen61@mcmaster.ca"
    end
end

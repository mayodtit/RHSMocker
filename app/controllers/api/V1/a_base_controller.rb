module Api
  module V1
    class ABaseController < ApplicationController
      before_filter :authentication_check

      def authentication_check
        auth_token = params[:auth_token]
        return render_failure({reason:"Invalid auth_token"}) if auth_token.blank?
        user = User.find_by_auth_token(auth_token)
        return render_failure({reason:"Invalid auth_token"}) unless user
        auto_login(user)
      end

      def render_success resp=Hash.new
        json = {status:"success", user_message:""}.merge(resp).as_json
        render :json => json
      end

      def render_failure resp=Hash.new, status=401
        json = {status:"failure", user_message:""}.merge(resp).as_json
        render :json => json, :status => status
      end

      private

      def testing_environment?
        %w(development staging test).include?(Rails.env)
      end
    end
  end
end

module Api
  module V1
    class ABaseController < ApplicationController
      before_filter :authentication_check

      def authentication_check
        auth_token = params[:auth_token]
        return render_failure({reason:"Invalid auth_token"}) if auth_token.blank?
        user = Member.find_by_auth_token(auth_token)
        return render_failure({reason:"Invalid auth_token"}) unless user
        auto_login(user)
      end

      def render_success resp=Hash.new
        json = {status_code: 200, status:"success", user_message:""}.merge(resp).as_json
        render :json => json
      end

      def render_failure resp=Hash.new, status=401
        headers["WWW-Authenticate"] = %(Basic realm="Better") if status == 401
        json = {status_code: status, status:"failure", user_message:""}.merge(resp).as_json
        render :json => json, :status => status
      end

      protected

      def index_resource(collection)
        render_success(resource_plural_symbol => collection)
      end

      def show_resource(resource)
        render_success(resource_singular_symbol => resource)
      end

      def create_resource(collection, resource_params)
        resource = collection.create(resource_params)
        if resource.errors.empty?
          render_success(resource_singular_symbol => resource)
        else
          render_failure({reason: resource.errors.full_messages.to_sentence}, 422)
        end
      end

      def update_resource(resource, resource_params)
        if resource.update_attributes(resource_params)
          render_success(resource_singular_symbol => resource)
        else
          render_failure({reason: resource.errors.full_messages.to_sentence}, 422)
        end
      end

      def destroy_resource(resource)
        if resource.destroy
          render_success
        else
          render_failure({reason: resource.errors.full_messages.to_sentence}, 422)
        end
      end

      def load_user!
        @user = params[:user_id] ? User.find(params[:user_id]) : current_user
        authorize! :manage, @user
      end

      private

      def resource_plural_symbol
        controller_name.pluralize.to_sym
      end

      def resource_singular_symbol
        controller_name.singularize.to_sym
      end

      def testing_environment?
        %w(development staging test).include?(Rails.env)
      end
    end
  end
end

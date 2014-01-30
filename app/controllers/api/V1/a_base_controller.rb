module Api
  module V1
    class ABaseController < ApplicationController
      before_filter :force_development_error!
      before_filter :force_development_lag!
      before_filter :authentication_check
      before_filter :convert_to_role

      def convert_to_role
        search_and_replace_to_role params
      end

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
        headers["WWW-Authenticate"] = %(BasicCustom realm="Better") if status == 401
        json = {status_code: status, status:"failure", user_message:""}.merge(resp).as_json
        render :json => json, :status => status
      end

      def decode_b64_image(base64_image)
        CarrierwaveStringIO.new(Base64.decode64(base64_image))
      end

      protected

      def search_and_replace_to_role(params)
        if params.is_a? Hash
          if params.key?(:to_role) && !params[:to_role].nil? && !params[:to_role].is_a?(Role)
            role_name = params[:to_role]
            role = Role.find_by_name role_name

            if !role
              render_failure({reason: "Could not find Role '#{role_name}' for to_role field"}, 400)
            end

            params[:to_role] = role
          end

          params.each do |key, value|
            search_and_replace_to_role value
          end
        end
      end

      def index_resource(collection, options={})
        render_success((options[:name] || resource_plural_symbol) => collection)
      end

      def show_resource(resource, options={})
        render_success((options[:name] || resource_singular_symbol) => resource)
      end

      def create_resource(collection, resource_params, options={})
        resource = collection.create(resource_params)
        if resource.errors.empty?
          render_success((options[:name] || resource_singular_symbol) => (resource.serializer(options[:serializer_options] || {}) || resource))
        else
          render_failure({reason: resource.errors.full_messages.to_sentence}, 422)
        end
      end

      def update_resource(resource, resource_params, options={})
        if resource.update_attributes(resource_params)
          render_success((options[:name] || resource_singular_symbol) => (resource.serializer(options[:serializer_options] || {}) || resource))
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

      def force_development_error!
        return unless %w(development devhosted).include? Rails.env
        return unless params[:error]
        case params[:error]
        when '401'
          render_failure({reason: 'Unauthorized'}, 401)
        when '403'
          render_failure({reason: 'Forbidden'}, 403)
        when '404'
          render_failure({reason: 'Not Found'}, 404)
        when '422'
          render_failure({reason: 'Unprocessable Entity'}, 422)
        else
          render_failure({reason: 'Internal Server Error'}, 500)
        end
      end

      def force_development_lag!
        return unless %w(development devhosted).include? Rails.env
        return unless params[:lag]
        sleep(10)
      end

      def resource_plural_symbol
        controller_name.pluralize.to_sym
      end

      def resource_singular_symbol
        controller_name.singularize.to_sym
      end

      def testing_environment?
        %w(development test).include?(Rails.env)
      end
    end
  end
end

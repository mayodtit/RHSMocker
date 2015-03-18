module Api
  module V1
    class ABaseController < ApplicationController
      before_filter :force_development_error!
      before_filter :force_development_lag!
      before_filter :authentication_check

      def authentication_check
        return render_failure({reason:"Invalid auth_token"}) if params[:auth_token].blank?
        @session = Session.find_by_auth_token(params[:auth_token])
        return render_failure({reason:"Invalid auth_token"}) unless @session
        member = @session.member
        return render_failure({reason:"Invalid auth_token"}) unless member
        time_out_check(@session)
        auto_login(member)
      end

      def time_out_check(session)
        if (Time.now - session.last_seen_at) < 900
          session.update_attributes(note: 'Your current session expired')
          render_failure({reason: session.note})
          session.destroy and return
        end
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

      def index_resource(collection, options={})
        render_success((options[:name] || resource_plural_symbol) => collection)
      end

      def show_resource(resource, options={})
        render_success((options[:name] || resource_singular_symbol) => resource)
      end

      def create_resource(collection, resource_params, options={})
        resource = collection.create(resource_params)
        if resource.errors.empty?
          resource.reload
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

      def load_member!
        @member = Member.find(params[:member_id])
      end

      def current_session
        @session
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

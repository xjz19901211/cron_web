module Support
  module RequestHelper
    extend ActiveSupport::Concern

    def send_req(ext_params = {}, ext_session = {})
      if @controller
        @_controller ||= @controller
        @controller = @_controller.clone
      end

      params = {}
      if req_args[:path] && req_args[:path] =~ /^\/api\//
        params.merge!(api_token: APP_CONFIG['api_token'])
      end
      params.merge!(req_args[:params].merge(ext_params))

      self.send(
        req_args[:method], req_args[:action] || req_args[:path],
        params, (req_args[:session] || {}).merge!(ext_session)
      )
    end

    def req_args
      @req_args ||= instance_eval(&self.class.req_args_proc)
    end

    def user_session
      {user_id: fetch_user('test').id}
    end


    module ClassMethods
      def set_req_args(&block)
        @req_args_proc = block
      end

      def req_args_proc
        return @req_args_proc if @req_args_proc

        if superclass.respond_to?(:req_args_proc)
          superclass.req_args_proc
        else
          raise %q{
            Not set req_args
            set_req_args do
              {
                method: :get,
                action: :index,
                params: {},
                session: {}
              }
            end
          }
        end
      end

      def request_should_be_ok
        it 'request should be ok' do
          send_req
          expect(response.status).to be_between(200, 299)
        end
      end

      def request_should_redirect
        it 'request should be redirect' do
          send_req
          expect(response).to be_redirect
        end
      end

      def request_should_redirect_to(&block)
        it 'request should be redirect' do
          send_req
          expect(response).to redirect_to(instance_eval(&block))
        end
      end


      def request_should_render_template(&block)
        it 'request should render view' do
          send_req

          expect(response).to render_template(instance_eval(&block))
        end
      end

    end
  end
end


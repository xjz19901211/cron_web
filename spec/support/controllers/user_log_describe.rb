RSpec.shared_examples 'create_action_user_log' do |model = nil|
  describe 'user_log' do
    def controller_name
      controller.controller_name
    end

    def controller_model
      eval(controller_name.classify)
    end

    it 'should create user log' do
      expect {
        send_req
      }.to change(UserLog, :count).by(1)
      model ||= controller_model

      sname = controller_name.singularize
      log_action = "#{req_args[:action]}-#{sname}"
      record_id = req_args[:action].to_s == 'destroy' ? assigns(sname.to_sym).id : model.last.id
      expect(UserLog.last.attributes.values_at(*%w{user_id action params})).to \
        eq([signed_user.id, log_action, {'id' => record_id}])
    end
  end
end

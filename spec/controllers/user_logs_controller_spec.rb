RSpec.describe UserLogsController, type: :controller do
  let(:user_log) { create_user_log('default') }

  describe "GET #index" do
    set_req_args do
      {
        action: :index,
        method: :get,
        params: {}
      }
    end

    it "assigns all user_logs as @user_logs" do
      send_req
      expect(assigns(:user_logs)).to eq([user_log])
    end
  end
end


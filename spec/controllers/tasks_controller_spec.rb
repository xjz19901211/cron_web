RSpec.describe TasksController, type: :controller do
  let!(:task) { create_task('a') }
  let(:work) { task.work }

  describe "GET #index" do
    set_req_args do
      {
        action: :index,
        method: :get,
        params: {work_id: work.to_param}
      }
    end

    it "assigns all tasks as @tasks" do
      send_req
      expect(assigns(:tasks)).to eq([task])
    end
  end

  describe "GET #show" do
    set_req_args do
      {
        action: :show,
        method: :get,
        params: {id: task.to_param}
      }
    end

    it "assigns the requested task as @task" do
      send_req
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET #start_code" do
    set_req_args do
      {
        action: :start_code,
        method: :get,
        params: {id: task.to_param}
      }
    end
    request_should_render_template { 'start_code' }

    it "assigns the requested task as @task" do
      send_req
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET #run_code" do
    set_req_args do
      {
        action: :run_code,
        method: :get,
        params: {id: task.to_param}
      }
    end

    it "assigns the requested task as @task" do
      send_req
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST #create" do
    set_req_args do
      {
        action: :create,
        method: :post,
        params: {work_id: work.to_param}
      }
    end
    request_should_redirect_to { assigns(:task) }
    include_examples 'create_action_user_log'

    before :each do
      allow_any_instance_of(CodeWorker).to receive(:perform)
    end

    it "creates a new Task" do
      expect {
        send_req
      }.to change(Task, :count).by(1)
    end

    it "assigns a newly created task as @task" do
      send_req
      task = assigns(:task)
      expect(task).to be_a(Task)
      expect(task).to be_persisted
      expect(task.attributes.values_at(*%w{work_id status})).to eql([work.id, 'pending'])
    end

    it "should create CodeWorker and perform" do
      cw = double(perform: true)
      expect(CodeWorker).to receive(:new).with(kind_of(Task)).and_return(cw)
      expect(cw).to receive(:perform)

      send_req
    end

    it 'creator should eql current user' do
      send_req
      expect(assigns(:task).reload.user).to eq(signed_user)
    end
  end
end


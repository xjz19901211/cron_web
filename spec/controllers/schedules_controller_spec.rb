RSpec.describe SchedulesController, type: :controller do
  let!(:schedule) { create_schedule('aa') }

  describe "GET #index" do
    set_req_args do
      {
        action: :index,
        method: :get,
        params: {}
      }
    end

    it "assigns all schedules as @schedules" do
      send_req
      expect(assigns(:schedules)).to eq([schedule])
    end
  end

  describe "GET #show" do
    set_req_args do
      {
        action: :show,
        method: :get,
        params: {id: schedule.to_param}
      }
    end

    it "assigns the requested schedule as @schedule" do
      send_req
      expect(assigns(:schedule)).to eq(schedule)
    end
  end

  describe "GET #new" do
    set_req_args do
      {
        action: :new,
        method: :get,
        params: {}
      }
    end

    it "assigns a new schedule as @schedule" do
      send_req
      expect(assigns(:schedule)).to be_a_new(Schedule)
    end
  end

  describe "GET #edit" do
    set_req_args do
      {
        action: :edit,
        method: :get,
        params: {id: schedule.to_param}
      }
    end

    it "assigns the requested schedule as @schedule" do
      send_req
      expect(assigns(:schedule)).to eq(schedule)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      set_req_args do
        {
          action: :create,
          method: :post,
          params: {schedule: {name: 'new_name', cron: '* * * * *'}}
        }
      end
      request_should_redirect_to { assigns(:schedule) }

      it "creates a new Schedule" do
        expect {
          send_req
        }.to change(Schedule, :count).by(1)
      end

      it "assigns a newly created schedule as @schedule" do
        send_req
        schedule = assigns(:schedule)
        expect(schedule).to be_a(Schedule)
        expect(schedule).to be_persisted
        expect(schedule.attributes.values_at(*%w{name cron})).to eq(['new_name', '* * * * *'])
      end
    end

    context "with invalid params" do
      set_req_args do
        {
          action: :create,
          method: :post,
          params: {schedule: {name: 'a', cron: '*** *'}}
        }
      end
      request_should_render_template { 'new' }

      it "assigns a newly created but unsaved schedule as @schedule" do
        send_req
        expect(assigns(:schedule)).to be_a_new(Schedule)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      set_req_args do
        {
          action: :update,
          method: :put,
          params: {id: schedule.to_param, schedule: {name: 'new_name'}}
        }
      end
      request_should_redirect_to { schedule }

      it "updates the requested schedule" do
        send_req
        expect(schedule.reload.name).to eq('new_name')
      end

      it "assigns the requested schedule as @schedule" do
        send_req
        expect(assigns(:schedule)).to eq(schedule)
      end
    end

    context "with invalid params" do
      set_req_args do
        {
          action: :update,
          method: :put,
          params: {id: schedule.to_param, schedule: {name: 'a'}}
        }
      end
      request_should_render_template { 'edit' }

      it "assigns the schedule as @schedule" do
        send_req
        expect(assigns(:schedule)).to eq(schedule)
      end
    end
  end

  describe "DELETE #destroy" do
    set_req_args do
      {
        action: :destroy,
        method: :delete,
        params: {id: schedule.to_param}
      }
    end
    request_should_redirect_to { schedules_path }

    it "destroys the requested schedule" do
      expect {
        send_req
      }.to change(Schedule, :count).by(-1)
    end
  end
end


RSpec.describe WorksController, type: :controller do
  let!(:work) { create_work('hello') }

  describe "GET #index" do
    set_req_args do
      {
        action: :index,
        method: :get,
        params: {}
      }
    end

    it "assigns all works as @works" do
      send_req
      expect(assigns(:works)).to eq([work])
    end
  end

  describe "GET #show" do
    set_req_args do
      {
        action: :show,
        method: :get,
        params: {id: work.to_param}
      }
    end

    it "assigns the requested work as @work" do
      send_req
      expect(assigns(:work)).to eq(work)
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

    it "assigns a new work as @work" do
      send_req
      expect(assigns(:work)).to be_a_new(Work)
    end
  end

  describe "GET #edit" do
    set_req_args do
      {
        action: :edit,
        method: :get,
        params: {id: work.to_param}
      }
    end

    it "assigns the requested work as @work" do
      send_req
      expect(assigns(:work)).to eq(work)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      set_req_args do
        {
          action: :create,
          method: :post,
          params: {
            work: {
              name: 'hello',
              input_args: [{key: 'k', val: 'v'}],
              code_lang: :ruby,
              code: 'puts 1',
            }
          }
        }
      end
      request_should_redirect { assigns(:work) }
      include_examples 'create_action_user_log'

      it "creates a new Work" do
        expect {
          send_req
        }.to change(Work, :count).by(1)
      end

      it "assigns a newly created work as @work" do
        send_req
        work = assigns(:work)
        expect(work).to be_a(Work)
        expect(work).to be_persisted
        expect(work.attributes.values_at(*%w{name input_args code_lang code})).to \
          eq(['hello', {'k' => 'v'}, 'ruby', 'puts 1'])
      end

      it 'creator should eql current_user' do
        send_req
        expect(assigns(:work).reload.user).to eq(signed_user)
      end
    end

    context "with invalid params" do
      set_req_args do
        {
          action: :create,
          method: :post,
          params: {
            work: {
              name: 'he',
              code_lang: :invalid,
            }
          }
        }
      end
      request_should_render_template { 'new' }

      it "assigns a newly created but unsaved work as @work" do
        send_req
        expect(assigns(:work)).to be_a_new(Work)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      set_req_args do
        {
          action: :update,
          method: :put,
          params: {
            id: work.id,
            work: {
              name: 'new_name',
              code: 'new_code'
            }
          }
        }
      end
      request_should_redirect_to { work }
      include_examples 'create_action_user_log'

      it "updates the requested work" do
        send_req
        expect(work.reload.attributes.values_at('name', 'code')).to eq(%w{new_name new_code})
      end

      it "assigns the requested work as @work" do
        send_req
        expect(assigns(:work)).to eq(work)
      end
    end

    context "with invalid params" do
      set_req_args do
        {
          action: :update,
          method: :put,
          params: {
            id: work.id,
            work: {
              name: 'nw',
              code_lang: 'e'
            }
          }
        }
      end
      request_should_render_template { 'edit' }

      it "assigns the work as @work" do
        send_req
        expect(assigns(:work)).to eq(work)
      end
    end
  end

  describe "DELETE #destroy" do
    set_req_args do
      {
        action: :destroy,
        method: :delete,
        params: {id: work.id}
      }
    end
    request_should_redirect_to { works_url }
    include_examples 'create_action_user_log'

    it "destroys the requested work" do
      expect {
        send_req
      }.to change(Work, :count).by(-1)
    end
  end
end


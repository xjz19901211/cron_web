RSpec.describe UsersController, type: :controller do
  let!(:user) { create_user('a') }

  describe "GET #index" do
    set_req_args do
      {
        action: :index,
        method: :get,
        params: {}
      }
    end

    it "assigns all users as @users" do
      send_req
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "GET #show" do
    set_req_args do
      {
        action: :show,
        method: :get,
        params: {id: user.to_param}
      }
    end

    it "assigns the requested user as @user" do
      send_req
      expect(assigns(:user)).to eq(user)
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

    it "assigns a new user as @user" do
      send_req
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET #edit" do
    set_req_args do
      {
        action: :edit,
        method: :get,
        params: {id: user.to_param}
      }
    end

    it "assigns the requested user as @user" do
      send_req
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      set_req_args do
        {
          action: :create,
          method: :post,
          params: {
            user: {email: 'hi@a.com', password: 'password'}
          }
        }
      end

      it "creates a new User" do
        expect {
          send_req
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        send_req
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        send_req
        expect(response).to redirect_to(User.last)
      end
    end

    context "with invalid params" do
      set_req_args do
        {
          action: :create,
          method: :post,
          params: {
            user: {email: 'a.com', password: '123'}
          }
        }
      end

      it "assigns a newly created but unsaved user as @user" do
        send_req
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        send_req
        expect(response).to render_template("new")
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
            id: user.to_param,
            user: {password: 'password2'}
          }
        }
      end

      it "updates the requested user" do
        expect {
          send_req
        }.to change { User.find(user.id).password == 'password2' }.to(true)
      end

      it "assigns the requested user as @user" do
        send_req
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        send_req
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      set_req_args do
        {
          action: :update,
          method: :put,
          params: {
            id: user.to_param,
            user: {password: '123'}
          }
        }
      end

      it "assigns the user as @user" do
        send_req
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        send_req
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    set_req_args do
      {
        action: :destroy,
        method: :delete,
        params: {id: user.to_param}
      }
    end

    it "destroys the requested user" do
      expect {
        send_req
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      send_req
      expect(response).to redirect_to(users_url)
    end
  end
end


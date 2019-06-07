require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject(:user) {
    User.create!(
      username: 'larry',
      password: 'password'
      # password_digest: '83y4uhsd87d743hdusytfaiey',
      # session_token: 'dhsa3984dha'
    )
  }

  describe "GET #new" do
    it "renders the user new" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      it "renders the new template" do
        post :create, params: { user: { username: 'larry' } }
        expect(response).to render_template(:new)
      end

      it "puts error messages in a flash" do
        post :create, params: { user: { username: 'larry' } }
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do
      it "should redirect to the user show page" do
        post :create, params: { user: { username: 'larry', password: '12345678' } }
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end

  describe "GET #edit" do
    it "renders the user edit template" do
      get :edit, params: { id: user.id } 
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with invalid params" do
      it "renders the edit template" do
        patch :update, params: { user: { username: 'larry', password: 'K' } }
        expect(response).to render_template(:edit)
      end

      it "puts error messages in a flash" do
        patch :update, params: { user: { username: 'larry', password: 'K' } }
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do
      it "should redirect to the user show page" do
        patch :update, params: { user: { username: 'larry', password: '12345678' } }
        expect(response).to redirect_to(user_url(user.id))
      end
    end
  end
end

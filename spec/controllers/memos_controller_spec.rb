require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe MemosController do

  # This should return the minimal set of attributes required to create a valid
  # Memo. As you add validations to Memo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: "A3", word_list: "ABC" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MemosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all memos as @memos" do
      memo = Memo.create! valid_attributes
      get :index, {}, valid_session
      assigns(:memos).should eq([memo])
    end
  end

  describe "GET show" do
    it "assigns the requested memo as @memo" do
      memo = Memo.create! valid_attributes
      get :show, {:id => memo.to_param}, valid_session
      assigns(:memo).should eq(memo)
    end
  end

  describe "GET new" do
    it "assigns a new memo as @memo" do
      get :new, {}, valid_session
      assigns(:memo).should be_a_new(Memo)
    end
  end

  describe "GET edit" do
    it "assigns the requested memo as @memo" do
      memo = Memo.create! valid_attributes
      get :edit, {:id => memo.to_param}, valid_session
      assigns(:memo).should eq(memo)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Memo" do
        expect {
          post :create, {:memo => valid_attributes}, valid_session
        }.to change(Memo, :count).by(1)
      end

      it "assigns a newly created memo as @memo" do
        post :create, {:memo => valid_attributes}, valid_session
        assigns(:memo).should be_a(Memo)
        assigns(:memo).should be_persisted
      end

      it "redirects to the created memo" do
        post :create, {:memo => valid_attributes}, valid_session
        response.should redirect_to(Memo.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved memo as @memo" do
        # Trigger the behavior that occurs when invalid params are submitted
        Memo.any_instance.stub(:save).and_return(false)
        post :create, {:memo => { "name" => "invalid value" }}, valid_session
        assigns(:memo).should be_a_new(Memo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Memo.any_instance.stub(:save).and_return(false)
        post :create, {:memo => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested memo" do
        memo = Memo.create! valid_attributes
        # Assuming there are no other memos in the database, this
        # specifies that the Memo created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Memo.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => memo.to_param, :memo => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested memo as @memo" do
        memo = Memo.create! valid_attributes
        put :update, {:id => memo.to_param, :memo => valid_attributes}, valid_session
        assigns(:memo).should eq(memo)
      end

      it "redirects to the memo" do
        memo = Memo.create! valid_attributes
        put :update, {:id => memo.to_param, :memo => valid_attributes}, valid_session
        response.should redirect_to(memo)
      end
    end

    describe "with invalid params" do
      it "assigns the memo as @memo" do
        memo = Memo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Memo.any_instance.stub(:save).and_return(false)
        put :update, {:id => memo.to_param, :memo => { "name" => "invalid value" }}, valid_session
        assigns(:memo).should eq(memo)
      end

      it "re-renders the 'edit' template" do
        memo = Memo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Memo.any_instance.stub(:save).and_return(false)
        put :update, {:id => memo.to_param, :memo => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested memo" do
      memo = Memo.create! valid_attributes
      expect {
        delete :destroy, {:id => memo.to_param}, valid_session
      }.to change(Memo, :count).by(-1)
    end

    it "redirects to the memos list" do
      memo = Memo.create! valid_attributes
      delete :destroy, {:id => memo.to_param}, valid_session
      response.should redirect_to(memos_url)
    end
  end

end

require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:plan) { FactoryBot.build(:plan) }
  let(:bearer_token) { jwt_token_1(user) }


  describe "GET /plans" do

    subject do
      request.headers[:token] = bearer_token
      # request.headers["Authorization"] = bearer_token
      get 'index'

    end
    context 'without token' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        plan.save
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid token' do
        it 'returns all the plans' do
          expect(subject).to have_http_status(200)
        end
      end
      context 'with invalid token' do
        let(:bearer_token) { 'frgfrgrgfgfd' }
        it 'returns all the plans' do
          expect(subject).to have_http_status(401)
        end
      end
    end
  end

  describe 'GET show' do
    subject do
      request.headers[:token] = bearer_token
      get :show, params: params
    end
    context 'Get Plan 'do
      context 'with Valid Id'do
        let(:params) {{id: 2}}
        it 'Return ID Not Found'do
          expect(subject).to have_http_status(404)
        end
      end
      context 'with invalid Id'do
        let(:params) {{id: plan.id}}
        it 'return a plan' do
          plan.save
          expect(subject).to have_http_status(200)
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "duration"=>"weekly", "price"=>"150.0", "active"=>true})
        end
      end
    end
  end

  describe 'POST create' do
    let(:params) { {name: plan.name, duration: plan.duration, price: plan.price, active: plan.active} }
    subject do
      request.headers[:token] = bearer_token
      post :create, params: params
    end
    context 'Create plan' do
      context 'with valid params' do
        it 'create plans' do
          expect(subject).to have_http_status(201)
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "duration"=>"weekly", "price"=>"150.0", "active"=>true})
        end
      end
      context 'with invalid params' do
        let(:params) { { plan: {name: "fefef" }} }
        it 'returns unprocessebleentity' do
          expect(subject).to have_http_status(422)
        end
      end
    end
  end

  describe 'PATCH Update' do
    let(:params) { {id: plan.id, price: 151} }
    subject do
      request.headers[:token] = bearer_token
      patch :update, params: params
    end
    context "with vaid data" do
      it "It return ok" do
        plan.save
        expect(subject).to have_http_status(200)
        expect(JSON.parse(subject.body)).to eq({"id"=>1, "duration"=>"weekly", "price"=>"151.0", "active"=>true})
      end
    end
    context "with invalid params" do
      let(:params) {   {id: plan.id, price: ""} }
      it "it not valid params" do
        plan.save
        expect(subject).to have_http_status(422)
      end
    end
    context 'with invalid id' do
      let(:params) {{id: 0}}
      it 'Update Plan' do
        plan.save
        expect(JSON.parse(subject.body)).to eq({"message"=>"Plan Not Found"})
        expect(subject).to have_http_status(404)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) {{id: plan.id}}
    subject do
      request.headers[:token] = bearer_token
      delete :destroy, params: params
    end
    context 'without token Delete Plan' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        plan.save
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid id' do
        it 'Delete Plan' do
          plan.save
          expect { subject}.to change(Plan, :count).from(1).to(0)
          expect(subject).to have_http_status(200)
        end
      end
      context 'with invalid id' do
        let(:params) {{id: 0}}
        it 'Delete Plan' do
          plan.save
          expect(JSON.parse(subject.body)).to eq({"message"=>"Plan Not Found"})
          expect(subject).to have_http_status(404)
        end
      end
    end
  end
end

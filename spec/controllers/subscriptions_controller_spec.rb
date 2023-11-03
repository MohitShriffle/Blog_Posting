require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:subscription){FactoryBot.build(:subscription,user_id: user.id)}
  let(:bearer_token) { jwt_token_1(user) }
  
  
  describe "GET /subscriptions" do
    subject do
      request.headers[:token] = bearer_token
      get 'index'
    end
    context 'without token' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        subscription.save
        byebug
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid token' do
        it 'returns subscription' do
          subscription.save
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "start_date"=>"2023-11-03", "end_date"=>"2023-11-10", "status"=>"active", "auto_renewal"=>true})
          expect(subject).to have_http_status(200)
        end
      end
      context 'with invalid token' do
        let(:bearer_token) { 'frgfrgrgfgfd' }
        it 'not return all subscription' do
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
    context 'Get subscription 'do 
      context 'with InValid Id'do
        let(:params) {{id: 2}}
        it 'Return ID Not Found'do
        byebug
          expect(JSON.parse(subject.body)).to eq({"message"=>"subscription Not Found"})
          expect(subject).to have_http_status(404)  
        end
      end 
      context 'with valid Id'do 
        let(:params) {{id: subscription.id}}
        it 'return a plan' do
          subscription.save
          byebug
          expect(subject).to have_http_status(200)  
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "start_date"=>"2023-11-03", "end_date"=>"2023-11-10", "status"=>"active", "auto_renewal"=>true})
        end
      end
    end
   end

  describe 'PATCH Update' do
    let(:params) { {id: subscription.id, status: 'expired'} }   
    subject do
      request.headers[:token] = bearer_token
      patch :update, params: params
    end
    context "Update Subscription" do
      context "with out token" do
        let(:bearer_token) { '' }
        it "return unauthorized" do
          subscription.save
          byebug
          expect(subject).to have_http_status(401)
          expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
        end
      end
      context "with token"do
        context "with vaid data" do
          it "It return ok" do
            subscription.save
            byebug
            expect(subject).to have_http_status(200)
            expect(JSON.parse(subject.body)).to eq({"id"=>1, "start_date"=>"2023-11-03", "end_date"=>"2023-11-10", "status"=>"expired", "auto_renewal"=>true})
          end
        end
        context "with invalid params" do
          let(:params) {{id: subscription.id, status: ""} } 
          it "it not valid params" do
            subscription.save 
            expect(subject).to have_http_status(422)
          end
        end
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
        byebug 
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid id' do
        it 'Delete Plan' do
          plan.save
          expect { subject}.to change(Plan, :count).from(1).to(0)
          expect(subject).to have_http_status(204)
        end
      end
      context 'with invalid id' do
        let(:params) {{id: 0}}
        it 'Delete Plan' do
          plan.save
          byebug
          expect(JSON.parse(subject.body)).to eq({"message"=>"Plan Not Found"})
          expect(subject).to have_http_status(404)
        end
      end
    end
  end
end

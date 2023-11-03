require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.build(:user) }
  # let(:bearer_token) { "Bearer #{token}" }
  # let(:token) do
  #   jwt_token_1(user)
  # end
  let(:bearer_token) { jwt_token_1(user) }
  
  describe "Get /users" do
    subject do
      request.headers[:token] = bearer_token
      get 'index'
    end
    context 'without token' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        user.save
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid token' do
        it 'returns all the users' do
          user.save
          expect(subject).to have_http_status(200)
        end
      end
    end
  end

  # describe "GET show" do
  #   let(:params){{user_id: user.id}}
  #   subject do 
  #     request.headers[:token]= bearer_token
  #     get :show
  #   end
  #   context 'without token' do
  #     let(:bearer_token){ '' }
  #     it 'return unauthorized' do
  #       expect(subject).to have_http_status(401)
  #       except(JSON.parse(subject.body)).to eq({"error" =>"Nil JSON web token"})
  #     end
  #   end
  #   context 'with token' do
         
  #      it 'returns user' do
  #       expect(subject).to have_http_status(200)
  #     end
  #   end
  # end
     
  describe 'POST create' do
    let(:params) {{name: user.name,user_name: user.user_name,email: user.email,password:user.password,type: "Normal"}}
    subject do
      post :create, params: params
    end
    context 'Create User' do
      context 'with valid params' do
        it 'create user' do 
          expect(subject).to have_http_status(201)
          expect(JSON.parse(subject.body)).to eq("id"=>1, "name"=>user.name, "user_name"=>user.user_name, "email"=>user.email, "type"=>user.type, "profile_picture_url"=>nil)
        end
      end
      context 'with invalid params' do
        let(:params) { {} }
        it 'returns not_found' do
          expect(subject).to have_http_status(422)
        end
      end
    end
  end

  describe 'GET /send_otp' do
    subject do
      request.headers[:token] = bearer_token
      get :send_otp, params: params
    end
    context 'Send Otp' do
      context 'with valid email'do
        let(:params) {{email: user.email}} 
        it 'send mail'do
          user.save
          expect(subject).to have_http_status(200)
        end
      end 
      context 'with invalidvalid email'do
        let(:params) {{email: "mk@gmail.com"}} 
        it 'Email address not found. Please check and try again.'do
          user.save
          expect(subject).to have_http_status(404)
        end
      end
      context 'with invalid email'do 
        let(:params) {{email: ""}}
        it 'Email not present' do
          user.save
          expect(JSON.parse(subject.body)).to eq({"error"=>"Email not present"}) 
        end
      end
    end
  end
end
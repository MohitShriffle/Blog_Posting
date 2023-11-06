require 'rails_helper'
RSpec.describe AuthenticationController, type: :controller do
  let(:user) { FactoryBot.create(:user,verified: true)}
  
  describe 'POST login' do
    let(:params) {{email: user.email, password:user.password }}
    subject do
      post :login, params: params
    end
    context 'Login User' do
      context 'with valid params' do
        it 'Login User' do
          expect(subject).to have_http_status(200)
        end
      end
      context 'Login User With invalid parameter' do
        context 'Login User With invalid email' do
          let(:params) { {email: "efefef"} }
          it 'returns not_found' do
            expect(subject).to have_http_status(401)
            expect(JSON.parse(response.body)).to eq({"error"=>"Unauthorized"})
          end
        end
        context 'Login User With invalid parameter' do
          let(:params) { {email: "efefef",password: "frfrf"} }
          it 'returns not_found' do
            expect(subject).to have_http_status(401)
            expect(JSON.parse(response.body)).to eq({"error"=>"Unauthorized"})
          end
        end
        context 'Login unverified User' do
          let(:user) { FactoryBot.create(:user,verified: false)}
          let(:params) { {email: user.email,password: user.password, verified: false} }
          it 'returns not_found' do
            expect(subject).to have_http_status(422)
            expect(JSON.parse(response.body)).to eq({"message"=>"You need to Verify Your Email"})
          end
        end
      end
    end
  end
end
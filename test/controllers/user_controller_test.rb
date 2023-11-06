# frozen_string_literal: true

require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  include TokenGenerator
  let(:user) { FactoryBot.create(:user) }
  let(:bearer_token) { "Bearer #{token}" }
  let(:token) do
    generate_token(user)
  end

  describe 'Get /users' do
    subject do
      # request.headers["Authorization"] = bearer_token
      get 'index'
    end
    context 'without token' do
      let(:bearer_token) { '' }
      it 'return unauthorized' do
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({ 'error' => 'Nil JSON web token' })
      end
    end
    context 'with token' do
      context 'with valid token' do
        it 'returns all the users' do
          expect(subject).to have_http_status(200)
        end
      end
    end
  end
end

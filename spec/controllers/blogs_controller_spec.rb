require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:blog) { FactoryBot.build(:blog,user_id: user.id) }
  let(:bearer_token) { jwt_token_1(user) }
  
  describe "GET /blogs" do

    subject do
      request.headers[:token] = bearer_token

      get 'index'
    end
    context 'without token' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        blog.save
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid token' do
        context 'Normal User' do 
          it 'Return Normal Blogs' do
            blog.save
            expect(subject).to have_http_status(200)
          end
        end
        context 'Premium User'do
          let(:user) { FactoryBot.create(:user,type: 'Premium') }
          let(:blog) { FactoryBot.build(:blog,user_id: user.id) }
          it 'return Premium Blogs' do
            blog.save
            expect(subject).to have_http_status(200)
          end
        end
      end
      context 'with invalid token' do
        let(:bearer_token) { 'frgfrgrgfgfd' }
        it 'return error messages' do
          
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
    context 'Get Blog'do
      context 'with Valid Id'do
        let(:params) {{id: 2}}
        it 'Return ID Not Found'do
          expect(subject).to have_http_status(404)
        end
      end
      context 'with invalid Id'do
        let(:params) {{id: blog.id}}
        it 'return a plan' do
          blog.save
          expect(subject).to have_http_status(200)
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "title"=> blog.title, "body"=>blog.body , "user_id"=>1})
        end
      end
    end
  end

  describe "GET /show_my_blogs" do

    subject do
      request.headers[:token] = bearer_token

      get 'show_my_blogs'
    end
    context 'without token' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        blog.save
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid token' do
        it 'returns all My blogs' do
          blog.save
          expect(subject).to have_http_status(200)
        end
      end
      context 'with invalid token' do
        let(:bearer_token) { 'frgfrgrgfgfd' }
        it 'returns errors messages' do
          blog.save
          expect(subject).to have_http_status(401)
        end
      end
    end
  end
  
  describe 'get /blog_read' do 
    subject do
      request.headers[:token] = bearer_token
      get :blog_read
    end
    context 'Blog read'do
      context 'Premium User' do
        let(:user) { FactoryBot.create(:user,type: 'Premium') }
        # let(:blog) { FactoryBot.build(:blog,user_id: user.id) }
        it 'all Blogs' do
          expect(subject).to have_http_status(200)
        end  
      end
      context 'Normal User' do
        context 'User blog_views_count < 5' do
          it "return 5 Blog With full contain" do
            expect { subject }.to change {user.reload.blog_views_count }.from(0).to(1)
            expect(subject).to have_http_status(200)
          end
        end
        context 'User blog_views_count > 5' do
          let(:user) { FactoryBot.create(:user,blog_views_count: 6) }
          it "return 5 Blogs with limited contain" do
            expect(subject).to have_http_status(200)
            # expect(assigns(:products).count).to be == 5 
          end
        end 
      end
    end
  end
  
  describe 'POST create' do
    let(:params) { {title: blog.title, body: blog.body, user_id: blog.user_id } }
    subject do
      request.headers[:token] = bearer_token
      post :create, params: params
    end
    context 'Create plan' do
      context 'with valid params' do
        it 'create blogs With Valid attributes' do
          expect(subject).to have_http_status(201)
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "title"=> blog.title, "body"=>blog.body , "user_id"=>1})
        end
      end
      context 'with invalid params' do
        let(:params) { {title: "", body: ""} }
        it 'returns unprocessebleentity' do
          expect(subject).to have_http_status(422)
        end
      end
    end
  end
  
  describe 'PATCH Update' do
    let(:params) { {id: blog.id, title: "Testing"} }
    subject do
      request.headers[:token] = bearer_token
      patch :update, params: params
    end
    context "with vaid data" do
      context "When blog_views_count < 2" do
        it "It return ok" do
          blog.save
          expect(subject).to have_http_status(200)
          expect(JSON.parse(subject.body)).to eq({"id"=>1, "title"=> "Testing", "body"=>blog.body , "user_id"=>1})
        end
      end
      context "When blog_views_count > 2" do
        let(:blog) { FactoryBot.build(:blog,user_id: user.id,modifications_count: 4) }
        it "It return messeges" do
          blog.save
          expect(subject).to have_http_status(403)
          expect(JSON.parse(subject.body)).to eq({"errors"=>"You have reached the maximum allowed modifications for this post."})
        end
      end
    end
    context "with invalid params" do
      let(:params) {   {id: blog.id, title: ""} }
      it "it not valid params" do
        blog.save
        expect(subject).to have_http_status(422)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let(:params) {{id: blog.id}}
    subject do
      request.headers[:token] = bearer_token
      delete :destroy, params: params
    end
    context 'without token Delete Blog' do
      let(:bearer_token) { '' }
      it "return unauthorized" do
        blog.save
        expect(subject).to have_http_status(401)
        expect(JSON.parse(subject.body)).to eq({"error"=>"Nil JSON web token"})
      end
    end
    context 'with token' do
      context 'with valid id' do
        it 'Delete Blog' do
          blog.save
          expect { subject}.to change(Blog, :count).from(1).to(0)
          expect(subject).to have_http_status(200)
        end
      end
      context 'with invalid id' do
        let(:params) {{id: 0}}
        it 'Delete Blog' do
          blog.save
          expect(JSON.parse(subject.body)).to eq({"message"=>"Blog Not Found"})
          expect(subject).to have_http_status(404)
        end
      end
    end
  end
end
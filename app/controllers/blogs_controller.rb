# frozen_string_literal: true

# class BlogsController
class BlogsController < ApplicationController
  before_action :set_blog, only: %i[show update destroy show_blog]
  def index
    blogs1 = [] 
  
    if @current_user.type == 'Premium'
      response = HTTParty.get('https://jsonplaceholder.typicode.com/posts')
      blogs1.concat(JSON.parse(response.body))
      blogs1.concat(Blog.all)
      render json: blogs1, status: :ok
    else
      @blogs = Blog.all
      render json: @blogs, status: :ok
    end
  end
  
  
  def show_blog
    if @current_user == 'Normal'
      if @current_user.views_count_within_24_hours >= 5
        limited_blog = {
          title: @blog.title,
          author: @blog.user.name,
          content: 'Content is restricted due to daily view limit.'
         }
        render json: limited_blog, status: :ok
      else
        BlogView.create(user: current_user, blog: blog, viewed_at: Time.now)
        render json: @blog, status: :ok
      end
    else
      render json: @blog,status: :ok
    end
  end

  def show
    if @current_user.type == 'Premium' || blog.user == @current_user
      render json: blog, status: :ok
    else
      user = @current_user
      if user.can_view_blog(blog)
        render json: blog
        BlogView.create(user:, blog:, viewed_at: Time.now)
      else
        render json: { errors: 'You have reached the maximum limit To show .' }, status: :forbidden
      end
    end
  end

  def create
    blog = @current_user.blogs.new(blog_params)
    if blog.save
      render json: blog, status: :created
    else
      render json: { errors: blog.error.full_messages }, status: :unprocessable_entity
    end
  end

  # def view_blog
  #   blog = Blog.find(params[:id])
  #   unless @current_user.type == "Premium" || blog.user == @current_user
  #     user = @current_user
  #     if user.can_view_blog(blog)
  #       render json: blog
  #       BlogView.create(user: user, blog: blog, viewed_at: Time.now)
  #     else
  #       render json: { errors: 'You have reached the maximum limit To show .' }, status: :forbidden
  #     end
  #   else
  #     render json: blog, status: :ok
  #   end
  # end

  def update
    return unless check_can_update?

    if @blog.update(blog_params)
      render json: @blog, status: :ok
      @blog.increment_modification_count
    else
      render json: { error: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def check_can_update?
    if @current_user.type == 'Premium'
      return true
    elsif @blog.user == @current_user && @blog.modifications_count < 2
      return true
    else
      render json: { errors: 'You have reached the maximum allowed modifications for this post.' }, status: :forbidden
    end

    false
  end

  def destroy
    return unless @blog.user == @current_user

    if @blog.destroy
      render json: { message: 'Blog Deleted succesfully' }, status: :no_content
    else
      render json: { errors: @blog.errors.full_messages }, status: :not_found
    end
  end

  private

  def blog_params
    params.require(:blog).permit(
      :title,
      :body,
      :user_id
    )
  end

  def set_blog
    @blog = Blog.find(params[:id])
  end
end

# frozen_string_literal: true

# class BlogsController
class BlogsController < ApplicationController
  before_action :set_blog, only: %i[show update destroy]
  before_action :authenticate_user
  load_and_authorize_resource

  def index
    blogs1 = []
    if @current_user.type == 'Premium'
      response = HTTParty.get('https://jsonplaceholder.typicode.com/posts')
      blogs1.concat(JSON.parse(response.body))
      blogs1.concat(Blog.all)
    else
      blogs = Blog.all
      blogs1 = blogs.page(params[:page])
    end
    render json: blogs1, status: :ok
  end

  def show
    return render json: @blog, status: :ok if @current_user.type == 'Premium' || @blog.user == @current_user

    if @current_user.can_view_blog(@blog)
      render json: @blog, status: :ok
      BlogView.create(user_id: @current_user.id, blog_id: @blog.id, viewed_at: Time.now)
    else
      limited_blog = { title: @blog.title, author: @blog.user.name,
                       message: 'You have reached the maximum limit To show' }
      render json: limited_blog, status: :ok
    end
  end

  def show_my_blogs
    render json: @current_user.blogs, status: :ok
  end

  def blog_read
    return render json: Blog.all, status: :ok unless @current_user.type == 'Normal'

    if @current_user.blog_views_count >= 5
      limited_blogs = Blog.where.not(user_id: @current_user.id).limit(5)
      render json: limited_blogs.map { |blog| { blog_id: blog.id, title: blog.title, author: blog.user.name } }
    else
      blogs_to_display = Blog.where.not(user_id: @current_user.id).sample(5)
      @current_user.update(blog_views_count: @current_user.blog_views_count + 1)
      render json: blogs_to_display, status: :ok
    end
  end

  def create
    blog = @current_user.blogs.new(blog_params)
    if blog.save
      render json: blog, status: :created
    else
      render json: { errors: blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    unless check_can_update
      return render json: { errors: 'You have reached the maximum allowed modifications for this post.' },
                    status: :forbidden
    end

    if @blog.update(blog_params)
      render json: @blog, status: :ok
      @blog.increment_modification_count
    else
      render json: { error: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def check_can_update
    return true if (@current_user.type == 'Premium') || (@blog.user == @current_user && @blog.modifications_count < 2)

    false
  end

  def destroy
    render json: { errors: 'Blog Deleted succesfully' } if @blog.destroy
  end

  private

  def blog_params
    params.permit(
      :title,
      :body,
      :user_id
    )
  end

  def set_blog
    render json: { message: 'Blog Not Found' }, status: 404 unless (@blog = Blog.find_by(id: params[:id]))
  end
end

# frozen_string_literal: true

# class BlogsController
class BlogsController < ApplicationController
  before_action :set_blog, only: %i[show update destroy]

  def index
    blogs = Blog.all
    if @current_user.type == 'Normal'
      blogs.each_with_index do |_b, i|
        next unless i < 5

        render json: blogs
        # else
        #   render json: blogs.title
      end
    else
      render json: blogs
    end
  end

  def show; end

  def create
    blog = @current_user.blogs.new(blog_params)
    if blog.save
      render json: blog, status: :created
    else
      render json: { errors: blog.error.full_messages }, status: :unprocessable_entity
    end
  end

  # def update
  #   if @current_user.type == "Normal"
  #     if @blog.user == @current_user && @blog.modifications_count < 2
  #       if @blog.update(blog_params)
  #         render json: @blog ,status: :ok
  #         @blog.increment_modification_count
  #       else
  #         render json: { error: @blog.errors.full_messages},status: :unprocessable_entity
  #       end
  #     else
  #       render json: { errors: "You have reached the maximum allowed modifications for this post." }, status: :forbidden
  #     end
  #   else
  #     if @blog.update(blog_params)
  #       render json: @blog ,status: :ok
  #       @blog.increment_modification_count
  #     else
  #       render json: { error: @blog.errors.full_messages},status: :unprocessable_entity
  #     end
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
    @blog = @current_user.blogs.find(params[:id])
  end
end

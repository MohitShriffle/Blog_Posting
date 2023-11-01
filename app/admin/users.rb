# frozen_string_literal: true

ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :user_name, :email, :password_digest, :otp, :otp_sent_at, :type, :subscription_id, :verified
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :user_name, :email, :password_digest, :otp, :otp_sent_at, :type, :subscription_id, :verified]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :name
    column :user_name
    column :email
    column :type
    actions
  end
  filter :name
  filter :user_name
  filter :email
  # blog_views_count :blog_views_count
  filter :type
  form do |f|
    f.inputs do
      f.input :name
      f.input :user_name
      f.input :email
      f.input :type
      f.input :password
      f.input :password_confirmation
      f.input :profile_picture, as: :file
    end
    f.actions
  end
  show do
    attributes_table do
      row :name
      row :user_name
      row :email
      if user.profile_picture.attached?
        row :profile_picture do |img|
          image_tag url_for(img.profile_picture), size: '120x120'
        end
      end
    end
  end

  # controller { actions :all, except: [:destroy] }

  # actions :index, :edit, :update, :create
  permit_params :name, :user_name, :email, :type, :password, :password_confirmation, :profile_picture
end

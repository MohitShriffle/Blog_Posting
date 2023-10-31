# frozen_string_literal: true

ActiveAdmin.register BlogView do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :viewed_at, :user_id, :blog_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:viewed_at, :user_id, :blog_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :viewed_at
    column :user_id
    column :blog_id
    actions
  end
  filter :viewed_at
  filter :user_id
  form do |f|
    f.inputs do
      f.input :viewed_at
      f.input :user_id
      f.input :blog_id
    end
    f.actions
  end
  show do
    attributes_table do
      row :viewed_at
      row :user_id
      row :blog_id
    end
  end
  permit_params :viewed_at, :user_id, :blog_id
end

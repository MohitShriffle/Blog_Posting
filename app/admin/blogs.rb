# frozen_string_literal: true

ActiveAdmin.register Blog do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :body, :user_id, :modifications_count
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :body, :user_id, :modifications_count]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :title
    column :body
    column :user
    actions
  end
  filter :title
  filter :body
  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :user_id
      f.input :modifications_count
    end
    f.actions
  end
  show do
    attributes_table do
      row :title
      row :body
      row :user_id
    end
  end

  # controller { actions :all, except: [:destroy] }

  # actions :index, :edit, :update, :create, :destroy
  permit_params :title, :body, :user_id, :modifications_count
end

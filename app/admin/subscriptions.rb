# frozen_string_literal: true

ActiveAdmin.register Subscription do
  index do
    column :start_date
    column :end_date
    column :status
    column :auto_renewal
    column :user_id
    column :plan_id
    actions
  end
  filter :start_date
  filter :end_date
  filter :status
  filter :auto_renewal
  form do |f|
    f.inputs do
      f.input :start_date
      f.input :end_date
      f.input :auto_renewal
      f.input :status
      f.input :user_id
      f.input :plan_id
    end
    f.actions
  end
  show do
    attributes_table do
      row :start_date
      row :end_date
      row :status
      row :auto_renewal
      row :user_id
      row :plan_id
    end
  end
  permit_params :start_date, :end_date, :status, :auto_renewal, :user_id, :plan_id
end

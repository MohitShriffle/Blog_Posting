# frozen_string_literal: true

ActiveAdmin.register Plan do
  index do
    column :name
    column :duration
    column :price
    column :active
    actions
  end
  filter :name
  filter :duration
  form do |f|
    f.inputs do
      f.input :name
      f.input :duration
      f.input :price
      f.input :active
    end
    f.actions
  end
  show do
    attributes_table do
      row :name
      row :duration
      row :price
      row :active
    end
  end
  permit_params :name, :duration, :price, :active
end

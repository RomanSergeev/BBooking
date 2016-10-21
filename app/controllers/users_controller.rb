class UsersController < ApplicationController
  def show
    #@user = User.preload(:profile).find(params[:id])
    @user = User.find(params[:id])
    render layout: "user"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.name = params[:user][:name]
    @user.update_attributes(name: params[:user][:name])
  end
end

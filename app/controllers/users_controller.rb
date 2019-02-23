class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  def index
    @users = User.all.where('id <> ?', current_user.id).order(:id)
  end

  def show
    @user = User.find(params[:id])
  end


end

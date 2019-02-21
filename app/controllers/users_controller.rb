class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  def index
    @users = User.all
  end

  def show
    @users = User.find(params[:id])
  end

end

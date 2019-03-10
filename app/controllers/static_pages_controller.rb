class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @user = current_user
      @posts = Post.where(author_id: @user).paginate(page: params[:page],
        per_page:10)
      render 'users/show'      
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :permit_more_parameters, if: :devise_controller?


  protected

  def show_post( new_comment = Comment.new(author: current_user))

    author = @post.author
    unless current_user == author || current_user.friends.include?(author)
      flash[:warning] = "You must be friends with #{author || 'them'} before viewing their posts."
      redirect_to posts_url and return
    end
    @comments = @post.comments.order(:created_at).paginate(page: params[:page]).per_page(10)
    @new_comment = new_comment

    render 'posts/show'
  end

  def permit_more_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end

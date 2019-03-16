class PicsController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_author, only: [:destroy]
  before_action :set_pic, only: [:show, :destroy]
  before_action :new_post, only: [:index]


  def show
    show_pic
  end

  def create
    @pic = current_user.pics.build(pic_params)

    if @pic.save
      redirect_to @pic
    else
      flash[:warning] = 'Image not saved'
      redirect_to user_pics_path(current_user)
    end
  end

  def destroy
  end

  def index
    if !(user = params[:user_id]&.to_i)
      @pics = current_user.pics_feed.paginate(page: params[:page])
    elsif (user == current_user.id) ||
      (current_user.friends.include?(User.find_by_id(user)))
      @pics = Pic.where(author_id: user).paginate(page: params[:page])
    else
      flash.now[:warning] = "You can only see your and your friends' pics."
      @pics = current_user.pics_feed.paginate(page: params[:page])
    end
  end

  private

  def confirm_author
    unless @pic.author == current_user
      flash[:warning] = 'You can only edit or delete your own pics.'
      redirect_to root_url
    end
  end

  def set_pic
    @pic = Pic.find_by_id(params[:id])
  end

  def pic_params
    params.require(:pic).permit(:author_id, :image)
  end
end

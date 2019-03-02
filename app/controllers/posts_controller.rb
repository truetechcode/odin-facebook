class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :confirm_author, only: [:edit, :update, :destroy]
  before_action :new_post, only: [:index, :new]
  # GET /posts
  def index
    if !(user = params[:user_id]&.to_i)
      @posts = current_user.feed.paginate(page: params[:page])
    elsif (user == current_user.id) || (current_user.friends.include?(user))
      @posts = Post.where(author_id: user).paginate(page: params[:page])
    else
      flash.now[:warning] = "You can only see your and your friends' posts."
      @posts = current_user.feed.paginate(page: params[:page])
    end
  end

  # GET /posts/1
  def show
    author = @post.author
    unless current_user == author || current_user.friends.include?(author)
      flash[:warning] = "You must be friends with #{author || 'them'} before viewing their posts."
      redirect_to posts_url
    end
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to @post, notice: 'Post was successfully created.'
      else
        render :new
      end
  end

  # PATCH/PUT /posts/1
  def update
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def new_post
      @post = Post.new
    end

    def confirm_author
      unless @post.author == current_user
        flash[:warning] = 'You can only edit or delete your own posts.'
        redirect_to root_url
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.fetch(:post, {}).permit(:author_id,:body)
    end



end

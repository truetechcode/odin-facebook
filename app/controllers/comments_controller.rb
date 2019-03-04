class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_post, only: [:create]
  before_action :confirm_commentable, only: [:create]
  before_action :confirm_author, only: [:edit, :update, :destroy]



  # GET /comments/1/edit
  def edit
  end

  # POST /posts/:post_id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.post = @post

    if @comment.save
      redirect_to @post, notice: 'Comment was successfully created.'
    else
      flash[:warning] = 'Comment not created'
      #redirect_to @post
      show_post(@comment)
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment.post, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    post = @comment.post
    @comment.destroy
    redirect_back fallback_location: post_path(post),
      notice: 'Comment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_post
      @post = Post.find_by_id(params[:post_id])
    end
    def confirm_commentable
      author = @post.author
      unless @post.author  == current_user ||
        @post.author.friends.include?(current_user)
        flash[:warning] =
          "You can only comment on your posts and your friend's posts"
        redirect_to posts_path
      end
    end
    def confirm_author
      unless @comment.author == current_user
        flash[:warning] = 'You can only edit and delete your own comments'
        redirect_to post_path(@comment.post)
      end
    end
end

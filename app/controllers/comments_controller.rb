class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_post_or_pic, only: [:create]
  before_action :confirm_commentable, only: [:create]
  before_action :confirm_author, only: [:edit, :update, :destroy]



  # GET /comments/1/edit
  def edit
  end

  # POST /posts/:post_id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.commentable = @commentable

    if @comment.save
      redirect_to @commentable, notice: 'Comment was successfully created.'
    else
      flash.now[:warning] = 'Comment not created'
      if @commentable.class == Post
        @post = @commentable
        show_post(@comment)
      elsif @commentable.class == Pic
        @pic = @commentable
        show_pic(@comment)
      else
        flash.now[:warning] = 'Can only create a comment for a post or pic.'
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    commentable = @comment.commentable
    @comment.destroy
    redirect_back fallback_location: commentable,
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

    def set_post_or_pic
      if post_id = params[:post_id]
        @commentable = Post.find_by_id(post_id)
      elsif pic_id = params[:pic_id]
        @commentable = Pic.find_by_id(pic_id)
      end
    end

    def confirm_commentable
      author = @commentable.author
      unless @commentable.author  == current_user ||
        @commentable.author.friends.include?(current_user)
        flash[:warning] =
          "You can only comment on your posts and your friend's posts"
        redirect_to posts_path
      end
    end
    def confirm_author
      unless @comment.author == current_user
        flash[:warning] = 'You can only edit and delete your own comments'
        redirect_to @comment.commentable
      end
    end
end

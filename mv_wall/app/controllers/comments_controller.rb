class CommentsController < ApplicationController
    def process_comment
        validations = Comment.validate_comment(user_comment_params)

        if validations.empty?
            comment = Comment.insert_comment(user_comment_params)
            flash[:notice] = 'Comment Added' if comment.present?
        else
            flash[:notice] = validations.join(', ')
        end 
        redirect_to '/blogs'
    end

    def edit_page
        @user = session[:user]
        @comment = Comment.get_comment(params[:id])
        
        render 'edit'
    end

    def process_edit
        validations = Comment.validate_comment(user_comment_params)

        if validations.empty?
            comment = Comment.update_comment(user_comment_params)
            flash[:notice] = 'Comment Edited' if comment.present?
        else
            flash[:notice] = validations.join(', ')
        end 
        redirect_to '/blogs'
    end

    def delete
        validations = Comment.validate_delete(comment_delete_params)

        if validations.empty?
            flash[:notice] = 'Comment not found/Contanct Author'
        else
            Comment.delete_comment(comment_delete_params)
        end 
        redirect_to '/blogs'
    end

    private

    def user_comment_params
        params.require(:comment).permit(:message_id, :user_id, :content)
    end 

    def comment_delete_params
        params.require(:comment_delete).permit(:comment_id, :user_id)
    end
end

class MessagesController < ApplicationController
    def process_message
        validations = Message.validate_message(user_message_params)

        if validations.empty?
            message = Message.insert_message(user_message_params)
            flash[:notice] = 'Message Added' if message.present?
        else
            flash[:notice] = validations.join(', ')
        end 
        redirect_to '/blogs'
    end

    def edit_page
        @user = session[:user]
        @message = Message.get_message(params[:id])

        render 'edit'
    end

    def process_edit
        validations = Message.validate_message(user_message_params)

        if validations.empty?
            message = Message.update_message(user_message_params)
            flash[:notice] = 'Message Edited' if message.present?
        else
            flash[:notice] = validations.join(', ')
        end 
        redirect_to '/blogs'
    end

    def delete
        validations = Message.validate_delete(message_delete_params)

        if validations.empty?
            flash[:notice] = 'Message not found/Contanct Author'
        else
            Message.delete_message(message_delete_params)
        end 
        redirect_to '/blogs'
    end

    private

    def user_message_params
        params.require(:message).permit(:user_id, :content)
    end 

    def message_delete_params
        params.require(:message_delete).permit(:message_id, :user_id)
    end
end

class MessagesController < ApplicationController
    before_action :authenticate_user!

    def create
      @chat = Chat.find(params[:chat_id])
      @message = @chat.messages.new(message_params)
      @message.user = current_user
  
      if @message.save
        # Broadcast the message using ActionCable
        ChatChannel.broadcast_to(@chat, message: @message.content, username: current_user.username)
        head :ok
      else
        render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def message_params
      params.require(:message).permit(:content)
    end
end

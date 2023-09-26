class ChatsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @chats = current_user.chats
    end
  
    def new
      @chat = Chat.new
    end
  
    def create
        @chat = Chat.new(chat_params)
        @chat.sender = current_user
      
        if @chat.save
          redirect_to chat_path(@chat), notice: 'Chat created successfully'
        else
          render 'new'
        end
    end
  
    def show
      @chat = Chat.find(params[:id])
      @message = Message.new
    end
  
    private
  
    def chat_params
      params.require(:chat).permit(:recipient_id)
    end
  end
  
class MessagesController < ApplicationController
  def index
    @messages = Message.where(
      '( "to_id"=? OR "from_id"=? ) AND ( "to_id"=? OR "from_id"=? )',
      current_user.id, current_user.id, params[:id], params[:id]
    ).order('created_at DESC')
  end

  def findByUser
    @messages = Message.where(
      '( "to_id"=? OR "from_id"=? ) AND ( "to_id"=? OR "from_id"=? )',
      current_user.id, current_user.id, params[:id], params[:id]
    ).order('created_at DESC')
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.to_email.blank?
      @message.errors.add(:to_id, :email_missing)
      render 'new'
      return
    end

    @message.from_id = current_user.id
    @message.to_id = User.where('"email" = ?', @message.to_email).first.id

    if @message.save
      redirect_to @message
    else
      render 'new'
    end
  end

  def show
    @messages = Message.find(params[:id])
  end

  private def message_params
    params.require(:message).permit(:to_email, :body)
  end
end

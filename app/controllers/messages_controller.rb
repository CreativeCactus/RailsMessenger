class MessagesController < ApplicationController
  # Represents a brief overview of chat history with a given ID and  email
  History = Struct.new(:msgs, :user, :email)

  def index
    contacts = get_contacts
    @hists = get_latest_correspondence(contacts)
  end

  def findByUser
    @messages = Message.where(
      '( "to_id"=? OR "from_id"=? ) AND ( "to_id"=? OR "from_id"=? )',
      current_user.id, current_user.id, params[:user], params[:user]
    ).order('created_at ASC')
    @email = user_id_to_email(params[:user])
    render 'find_by_user'
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

    if @message.to_email == current_user.email
      @message.errors.add(:to_id, :email_invalid)
      render 'new'
      return
    end

    @message.from_id = current_user.id
    @message.to_id = user_email_to_id(@message.to_email)

    if @message.save
      redirect_to action: 'findByUser', user: @message.to_id
    else
      render 'new'
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  private def message_params
    params.require(:message).permit(:to_email, :body)
  end

  # Get contact with whom messages are shared
  private def get_contacts
    sent = Message.where('"to_id" = ?', current_user.id).map(&:from_id)
    recv = Message.where('"from_id" = ?', current_user.id).map(&:to_id)

    (sent + recv).uniq
  end

  # return up to n most recent messages for given user IDs
  private def get_latest_correspondence(contacts, n = 3)
    message_ids = Message.where(
      '( "to_id" IN (?) AND "from_id" = ? ) OR ( "from_id" IN (?) AND "to_id" = ? )',
      contacts, current_user.id, contacts, current_user.id
    ).order('created_at DESC').map(&:id)

    latest_messages = Message.where(id: message_ids)
                             .order('created_at DESC')
                             .group_by { |msg| msg.to_id + msg.from_id }
                             .map do |_i, msgs|
      peer_id = msgs.first.to_id == current_user.id ?
        msgs.first.from_id : msgs.first.to_id
      History.new(msgs.first(n), peer_id, user_id_to_email(peer_id))
    end

    latest_messages
  end
end

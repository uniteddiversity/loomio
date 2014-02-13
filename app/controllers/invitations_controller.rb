class InvitationsController < ApplicationController
  include InvitationsHelper

  rescue_from ActiveRecord::RecordNotFound do
    render 'application/display_error',
      locals: { message: t(:'invitation.invitation_not_found') }
  end

  rescue_from Invitation::InvitationCancelled do
    render 'application/display_error',
      locals: { message: t(:'invitation.invitation_cancelled') }
  end

  rescue_from Invitation::InvitationAlreadyUsed do
    if current_user and @invitation.accepted_by == current_user
      redirect_to @invitation.invitable
    else
      render 'application/display_error',
        locals: { message: t(:'invitation.invitation_already_used') }
    end
  end


  def show
    clear_invitation_token_from_session
    @invitation = Invitation.find_by_token(params[:id])

    if @invitation.nil?
      raise ActiveRecord::RecordNotFound
    end

    if @invitation.cancelled?
      raise Invitation::InvitationCancelled
    end

    if @invitation.accepted?
      raise Invitation::InvitationAlreadyUsed
    end

    if current_user
      AcceptInvitation.and_grant_access!(@invitation, current_user)
      redirect_to @invitation.invitable
    else
      save_invitation_token_to_session
      redirect_to new_user_registration_path
    end
  end

  private

  def join_or_setup_group_path
    group = @invitation.invitable
    if group.admins.include? current_user
      setup_group_path(group)
    else
      group_path(group)
    end
  end
end

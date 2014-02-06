class Discussions::InvitationsController < GroupBaseController

  def new
    @invite_people_form = InvitePeopleForm.new
    @discussion = Discussion.find(params[:discussion_id])
    @group = @discussion.group
    load_decorated_group
  end


  def create
    @discussion = Discussion.find(params[:discussion_id])
    @group = @discussion.group
    @invite_people_form = InvitePeopleForm.new(params[:invite_people_form])
    MembershipService.add_users_to_group(users: @invite_people_form.members_to_add,
                                         group: @group,
                                         inviter: current_user)


    CreateInvitation.to_discussion_and_email_people(recipient_emails: @invite_people_form.emails_to_invite,
                                              message: @invite_people_form.message_body,
                                              discussion: @discussion,
                                              inviter: current_user)

    set_flash_message
    redirect_to discussion_path(@discussion)
  end

  private

  def load_decorated_group
    group
  end

  def set_flash_message
    unless @invite_people_form.emails_to_invite.empty?
      invitations_sent = t(:'notice.invitations.sent', count: @invite_people_form.emails_to_invite.size)
    end

    unless @invite_people_form.members_to_add.empty?
      members_added = t(:'notice.invitations.auto_added', count: @invite_people_form.members_to_add.size)
    end

    # expected output: 6 people invitations sent, 10 people added to group
    message = [invitations_sent, members_added].compact.join(", ")
    flash[:notice] = message
  end
end

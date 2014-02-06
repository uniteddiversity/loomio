class Discussions::InvitationsController < GroupBaseController

  def new
    @invite_people_form = InvitePeopleForm.new
    @discussion = Discussion.find(params[:discussion_id])
    @group = @discussion.group
    load_decorated_group
  end

  def load_decorated_group
    group
  end
end

  def create
    @invite_people_form = InvitePeopleToForm.new(params[:invite_people_form])
    MembershipService.add_users_to_group(users: @invite_people_form.members_to_add,
                                         group: @group,
                                         inviter: current_user)


    CreateInvitation.to_people_and_email_them(recipient_emails: @invite_people_form.emails_to_invite,
                                              message: @invite_people_form.message_body,
                                              group: @group,
                                              inviter: current_user)

    set_flash_message
    redirect_to group_path(@group)
  end

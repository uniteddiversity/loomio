module VotesHelper
  def vote_button(motion: nil, position: nil)
    position_key = "#{position}_position"
    link_to image_tag("hand-#{position}.png", title: t(position_key), alt: t(position_key)),
            new_motion_vote_path(motion_id: motion.id, position: position),
            "title" => t(position_key),
            "data-content" => t("#{position}_details"),
            class: "position btn vote-#{position}",
            id: "#{position}-vote"
  end

  def vote_submit_button_text
    if action_name == 'new'
      return t("vote_form.submit")
    else
      return t("vote_form.update")
    end
  end

  def vote_icon_name(position)
    if position
      icon_name = 'position-yes-icon' if position == "yes"
      icon_name = 'position-abstain-icon' if position == "abstain"
      icon_name = 'position-no-icon' if position == "no"
      icon_name = 'position-block-icon' if position == "block"
    else
      icon_name = "position-unvoted-icon"
    end
    icon_name
  end
end

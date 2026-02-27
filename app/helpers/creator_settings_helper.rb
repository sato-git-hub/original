module CreatorSettingsHelper
  def creator_setting_link_path
    if current_user.creator_setting.present?
      edit_creator_setting_path(current_user.creator_setting)
    else
      new_creator_setting_path
    end
  end
end

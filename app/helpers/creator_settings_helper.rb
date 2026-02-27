module CreatorSettingsHelper
  def creator_setting_link_path
    if current_user.creator_setting.present?
      edit_creator_setting_path
    else
      new_creator_setting_path
    end
  end
end

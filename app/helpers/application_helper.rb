module ApplicationHelper
  def show_header?
    return false if controller_name.in?(%w[sessions requests users portfolios edit]) && action_name.in?(%w[new edit])
    return false if controller_name == "settings"
    true
  end
end

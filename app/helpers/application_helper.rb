module ApplicationHelper
  def show_header?
    return false if devise_controller?
    return false if controller_name.in?(%w[requests portfolios]) && action_name.in?(%w[new edit])
    true
  end
end

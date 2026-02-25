module ApplicationHelper
  def show_header?
    return false if devise_controller?
    return false if controller_name.in?(%w[requests creator_settings]) && action_name.in?(%w[new edit])
    true
  end
end

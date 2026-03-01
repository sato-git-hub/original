module ApplicationHelper
  def default_image(image)
    image.variant(resize_to_limit: [600, 600])
  end
end

module UsersHelper
    def user_avatar(user, size: :base)
      size_class = {
        sm: "w-15",
        base: "w-20",
        lg: "w-30"
      }[size]
    if user.avatar.attached?
      image_tag(
        user.avatar.variant(
          resize_to_fill: [300, 300, { gravity: "North" }]
        ),
        class: "h-auto #{size_class} rounded-full"
      )
    else
      image_tag(
        "default_avatar.jpg",
        class: "h-auto #{size_class} rounded-full"
      )
    end
  end
end

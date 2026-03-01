module UsersHelper
  def user_avatar(user, size = 50, **options)
    # 1. クラスの合体（基本クラス + 引数で渡された任意のクラス）
    combined_classes = "user-avatar-helper #{options[:class]}".strip

    # 2. 画像パスの決定
    image_path = if user.avatar.attached?
                   user.avatar
                 else
                   "default_avatar.jpg"
                 end

    # 3. image_tag の生成
    # style属性に --size: 80px; のような形で数値を渡す
    image_tag(
      image_path,
      class: combined_classes,
      style: "--size: #{size}px;"
    )
  end
end

# <%=user_avatar(@user, 80, class:"user-avatar")%>
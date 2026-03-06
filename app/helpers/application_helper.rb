module ApplicationHelper
  def default_image(image)
    image.variant(resize_to_limit: [600, 600])
  end

  def link_to_back_with_icon(path: :back, text: "戻る", top: "-100px", left: "-120px")
    # スタイルを1箇所にまとめる
    link_style = "display: flex; align-items: center; position: absolute; top: #{top}; left: #{left}; text-decoration: none; color: inherit;"
    
    link_to path, style: link_style do
      concat content_tag(:span, "<", style: "font-size: 40px;")
      concat content_tag(:span, "#{text}", class: "font-bold mt-2 ml-2", style: "font-size: 20px;")
    end
  end
end

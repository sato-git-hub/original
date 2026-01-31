class Character < ApplicationRecord
  belongs_to :request

    enum hair_color: {
    black:   "黒",
    brown:   "茶色",
    blonde:  "金",
    silver:  "銀",
    red:     "赤",
    pink:    "ピンク",
    blue:    "青",
    yellow: "黄",
    green:   "緑",
    purple:  "紫",
    orange:  "オレンジ",
    white:   "白",
    gray:    "グレー"
  }

  # 髪型
  enum hair_style: {
 
  layered:      "レイヤー",
  mash:         "マッシュ",

  # 結び髪
  ponytail:     "ポニーテール",
  twintails:    "ツインテール",
  halfup:       "ハーフアップ",
  braid:        "三つ編み",
  french_braid: "編み込み",
  bun:          "お団子",
  side_ponytail:	"サイドポニー",
  two_side_up: 	"ツーサイドアップ",
  low_twintails: "ローツイン",
  double_bun:	"二つお団子",
  drill_hair:	"縦ロール	",
  matome: "まとめ髪",


  # 刈り上げ・ショート系
  two_block:    "ツーブロック",
  kariage:     "刈り上げ",


  messy:        "無造作系",
  spiky:        "とげとげ系",
  wolf:         "ウルフ",

  # ノーセット
  no_set:       "ノーセット"

}

enum bang_style: {
  full:        "前髪あり",
  pattunn: "ぱっつん",
  on_mayu: "オン眉",
  center:      "センターパート",
  side:        "サイドパート",
  kakiage:     "かきあげ",
  slick_back:  "オールバック",
  up_bang:     "アップバング"
}


enum hair_length: {
  very_short:   "ベリーショート",
  buzz_cut:     "坊主",
  short_cut: "短髪",
  short:        "ショート",
  bob:          "ボブ",
  medium:       "ミディアム",
  semi_long:    "セミロング",
  long:         "ロング",
  below_hips:   "お尻以上"
}

  enum hair_type: {
    straight: "ストレート",
    wavy:     "ウェーブ",
    perm:  "パーマ",
    natural_perm:  "天然パーマ"
  }

  # 肌色
  enum skin_tone: {
    fair:    "色白",
    pale_orange:  "ペールオレンジ",
    tan:     "小麦色",
    dark:    "褐色"
  }

  # 体型
  enum body_type: {
    slim:     "スリム",
    normal:   "普通",
    muscular: "筋肉質",
    chubby:   "ぽっちゃり"
  }

  # 骨格
  enum body_frame: {
    straight_frame: "ストレート",
    natural_frame:  "ナチュラル",
    wave_frame: "ウェーブ"
  }

  # パーソナルカラー
  enum personal_color: {
    spring: "春",
    summer: "夏",
    autumn: "秋",
    winter: "冬"
  }

  # 性別
  enum sex: {
    male:   "男性",
    female: "女性",
    other:  "その他"
  }

  # 目の色
  enum eye_color: {
    black_eye:   "黒",
    brown_eye:   "茶色",
    blonde_eye:  "金",
    silver_eye:  "銀",
    red_eye:     "赤",
    pink_eye:    "ピンク",
    blue_eye:    "青",
    yellow_eye: "黄",
    green_eye:   "緑",
    purple_eye:  "紫",
    orange_eye:  "オレンジ",
    white_eye:   "白",
    gray_eye:    "グレー"
  }

  # 目の形
  enum eye_shape: {
    round_eye:   "丸目",
    almond_eye:  "アーモンド型",
    hooded_eye:  "奥二重",
    monolid_eye: "一重",
    itome: "糸目",
    sannpakugann: "三白眼",
    odd_eye: "オッドアイ"
  }

  # MBTI
  enum mbti: {
    INTJ: "INTJ",
    INTP: "INTP",
    ENTJ: "ENTJ",
    ENTP: "ENTP",
    INFJ: "INFJ",
    INFP: "INFP",
    ENFJ: "ENFJ",
    ENFP: "ENFP",
    ISTJ: "ISTJ",
    ISFJ: "ISFJ",
    ESTJ: "ESTJ",
    ESFJ: "ESFJ",
    ISTP: "ISTP",
    ISFP: "ISFP",
    ESTP: "ESTP",
    ESFP: "ESFP"
  }

  # 顔タイプ
  enum face_type: {
    usagi:    "ウサギ顔",   # 目が大きくて可愛らしい
    neko:     "ネコ顔",     # クールでシャープな印象
    kuma:     "クマ顔",     # 丸顔で優しい印象
    kitsune:  "キツネ顔",   # シャープで知的
    inu:      "イヌ顔",     # 優しくて親しみやすい
    kawauso:  "カワウソ顔", # 愛嬌がある
    hachurui: "爬虫類顔",   # クールでミステリアス
    tanuki:   "タヌキ顔",   # 丸くて親しみやすい
    risu:     "リス顔"      # 元気で活発
  }

  # 顔型
  enum face_shape: {
    round_face:   "丸",
    square_face:    "四角",
    triangle_face:  "逆三角",
    long_face:    "面長",
    oval_face:    "卵型",
    base_face: "ベース型"
  }
end

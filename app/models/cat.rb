class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true

  validates :color, inclusion: { in: %w(black white orange),
     message: "#color isn't valid!" }

  validates :sex, inclusion: { in: %w(M F),
     message: "#sex isn't valid!" }

  has_many :cat_rental_requests, dependent: :destroy

  def age
    # QUESTION -- BETTER WAY? No
    Time.now.year.to_i - birth_date.to_s[0..3].to_i
  end

end

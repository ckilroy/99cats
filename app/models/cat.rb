class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true

  validates :color, inclusion: { in: %w(black white orange),
     message: "#{color} isn't valid!" }

  validates :sex, inclusion: { in: %w(M F),
     message: "#{sex} isn't valid!" }

  def age
    Time.now - birth_date
  end

end

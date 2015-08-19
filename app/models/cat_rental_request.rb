class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED),
      message: "#status isn't valid!" }

  validate :not_overlapping_approved_requests     # validates need attribute

  belongs_to :cat

  belongs_to :user

  def after_initialize
    self.status ||= 'PENDING'
  end

  def pending?
    self.status == 'PENDING'
  end

  def approve!
    self.transaction do
      approve_me
      deny_others
    end
  end
  # transaction listens to errors -- must try to raise exceptions inside! will rollback if receives exception

  def approve_me
    self.update!(status: 'APPROVED')
  end

  def deny_others
    overlapping_pending_requests.each do |request|
      request.update!(status: 'DENIED')
    end
  end

  def deny!
    self.update!(status: 'DENIED')
  end

  def not_overlapping_approved_requests     # returns true if overlapping
    if overlapping_requests.any? { |request| request.status == 'APPROVED' } &&
      self.status == 'APPROVED'
      errors[:status] << "Can't overlap with approved requests"
    end
  end

  def overlapping_pending_requests
    overlapping_requests.select { |request| request.status == 'PENDING' }
  end

  def overlapping_requests
    all_requests = cat.cat_rental_requests

    all_requests
      .where("cat_rental_requests.id != ? OR ? IS NULL", id, id)
      .where("NOT (cat_rental_requests.start_date > '#{end_date}' OR
              '#{start_date}' > cat_rental_requests.end_date)")
      # above are scenarios where
  end

  def overlapping_requests_old
    all_requests = cat.cat_rental_requests

    date_criterion = "BETWEEN '#{start_date}' AND '#{end_date}'"
    all_requests
      .where("cat_rental_requests.id != ? OR ? IS NULL", id, id)
      .where("cat_rental_requests.start_date #{date_criterion} OR
              cat_rental_requests.end_date #{date_criterion}")
  end

end

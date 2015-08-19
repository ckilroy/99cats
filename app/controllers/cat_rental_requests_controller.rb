class CatRentalRequestsController < ApplicationController
  before_action :check_cat_ownership, only: [:approve, :deny]

  def index
    @cat_rental_request = CatRentalRequest.all
    render json: @cat_rental_request
  end

  def new
    @cat_rental_request = CatRentalRequest.new

    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat_rental_request.user_id = current_user.id

    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat) #calls :id on the object
    else
      render @cat_rental_request.errors.full_messages
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    render text: "Approved!"
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    render text: "Denied!"
  end

  private

  def cat_rental_request_params
    params
      .require(:cat_rental_request)
      .permit(:cat_id, :start_date, :end_date, :status, :user_id)
  end

end

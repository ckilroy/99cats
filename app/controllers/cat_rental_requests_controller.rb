class CatRentalRequestsController < ApplicationController

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
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat) #calls :id on the object (unless object is integer)
    else
      render @cat_rental_request.errors.full_messages
    end
  end

  def update
    debugger
    @cat_rental_request = CatRentalRequest.find(params[:cat_rental_request][:id])
    @cat_rental_request.deny!

    render text: "need to work more on this"
  end

  private

  def cat_rental_request_params
    params
      .require(:cat_rental_request)
      .permit(:cat_id, :start_date, :end_date, :status)
  end

end

class CatsController < ApplicationController

  before_action :check_cat_ownership, only: [:edit, :update]

  def index
    @cat = Cat.all

    render json: @cat
  end

  def show
    @cat = Cat.find(params[:id])

    render :show
  end

  def edit
    @cat = Cat.find(params[:id])    # do we need to call update anywhere or template does this

    render :edit
  end

  def new               # this is here so we can access creation from cats/new
    @cat = Cat.new     # so populates fields with empty attributes and doesnt throw error

    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    # create by association instead -- though will override user_id if permitted
    # make new cat associated with that user, with foreign_key user_id
    # Preferred, because don't want strangers creating cats.

    @cat.save ? render(:show) : render(:new)
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update(cat_params)
      render :show
    else
      render :new
    end
  end

  private

  def cat_params
    params.require(:cat)
          .permit([:birth_date, :name, :color, :sex, :description])
  end

end

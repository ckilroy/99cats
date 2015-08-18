class CatsController < ApplicationController

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
    render :_form
  end

  def new               # this is here so we can access creation from cats/new
    @cat = Cat.new     # so populates fields with empty attributes and doesnt throw error
    render :_form
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      render :show
    else
      render @cat.errors.full_messages
    end
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      render :show
    else
      render @cat.errors.full_messages
    end
  end

  private

  def cat_params
    params.require(:cat).permit([:birth_date, :name, :color, :sex, :description])
  end

end

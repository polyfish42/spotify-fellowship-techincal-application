class Api::EventsController < ApplicationController
  def create
    @event = Event.new(event_params)

    if @event.save
      render 'api/events/show'
    else
      render json: {errors: @event.errors.full_messages}, status: 400
    end
  end

  def show
    @event = Event.find(params[:id])

    render 'api/events/show'
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(event_params)
      render 'api/events/show'
    else
      render json: { errors: @event.errors.full_messages }, status: 400
    end
  end

  def index
    @events = Event.all
    
    render 'api/events/index'
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!
    render 'api/events/show'
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :description)
  end
end

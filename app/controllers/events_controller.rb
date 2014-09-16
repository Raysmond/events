class EventsController < ApplicationController
	def index
		@events = Event.order(id: :desc).page(params[:page]).per(10)
	end
end
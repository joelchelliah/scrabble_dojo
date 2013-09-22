class SessionsController < ApplicationController

	def new

	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
	  	log_in user
	  	flash[:success] = "Welcome to Scrabble Dojo!"
      redirect_back_or root_url
	  else
	    flash.now[:error] = 'Invalid email/password combination'
	    render 'new'
	  end
	end

	def destroy
		log_out
    redirect_to root_url
	end
end

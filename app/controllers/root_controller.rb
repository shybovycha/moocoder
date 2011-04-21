class RootController < ApplicationController
	def auth
		if session[:user] == "moo"
			session[:user] = nil
		else
			session[:user] = "moo"
		end

		#redirect_to :back or 
		redirect_to "/"
	end
end

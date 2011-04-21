module ApplicationHelper
	def auth?
		if session[:user] == "moo"
			true
		else
			false
		end
	end
	
=begin
	def auth!
		if session[:user]
			session[:user] = false
		else
			session[:user] = true
		end
	en
=end
end

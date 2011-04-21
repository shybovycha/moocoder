module ApplicationHelper
	def link_bunch(links)
		a = []
		
		links.each do |l|
			a << link_to(l[0], l[1])
		end
		
		return a.join(" | ").html_safe
	end
	
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

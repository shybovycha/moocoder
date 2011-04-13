class Solution < ActiveRecord::Base
	belongs_to :problem
	belongs_to :compiler
end

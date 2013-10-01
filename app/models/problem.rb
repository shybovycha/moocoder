class Problem < ActiveRecord::Base
    has_many :solutions
    has_many :solution_tests
end

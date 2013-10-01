class Compiler < ActiveRecord::Base
    has_many :solutions
    has_many :build_steps
end

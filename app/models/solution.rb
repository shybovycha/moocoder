class Solution < ActiveRecord::Base
    belongs_to :compiler
    belongs_to :user
    belongs_to :problem

    def retest
        update_attribute :status, nil
    end
end

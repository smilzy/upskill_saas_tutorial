class PagesController < ApplicationController
    # GET request dla / czyli home page
    def home
        @basic_plan = Plan.find(1)
        @pro_plan = Plan.find(2)
    end

    def about
    end
    
end

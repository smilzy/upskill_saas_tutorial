# Tworzymy nową klasę, która dziedziczy po klasie z Devise - RegistrationsController
# Wyzwalamy funkcję "create", która się tam znajduje i rozszerzamy ją.
# Rozszerzamy o "jeżeli są parametry >:plan< w adresie URL" to
# Ustaw parametr >:plan< na cechę plan_id elementu >resource<, czyli użykownika
# Jeżeli ktoś wybrał plan 2, czyli PRO, to wywołaj funkcję .save_with_subscription
# Którą to funkcję zaraz utworzymy w MODELU users.rb.
# Jeżeli nie, to zwykły save (plan basic).

#Przed akcją "new", wywołaj oskryptowane na dole "select_plan"
#Czyli zabezpieczenie, że użytkownik wybrał poprawny plan.
class Users::RegistrationsController < Devise::RegistrationsController
    before_action :select_plan, only: :new    
    
    # Extend default Devise gem behavior so that 
    # users signing up with the Pro account (plan_id 2)
    # save with a special Stripe subscription function.
    # Otherwise Devise signs up uesr as usual.
    def create
        super do |resource| # super do oznacza ze dziedziczymy akcje "create" i rozszerzamy ją
            if params[:plan]
                resource.plan_id = params[:plan]
                if resource.plan_id == 2
                    resource.save_with_subscription 
                else
                    resource.save
                end
            end
        end
    end


#Czesc odpowiedzialna za upewnienie się, że użytkownik wybrał plan,
#A nie kombinuje z parametrami linku typu plan_id=50.
    private
     def select_plan
            unless (params[:plan] == '1' || params[:plan] == '2')
              flash[:notice] = "Please select a membership plan to sign up."
              redirect_to root_url
            end
        end
end
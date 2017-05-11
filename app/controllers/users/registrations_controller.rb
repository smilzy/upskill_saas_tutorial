# Tworzymy nową klasę, która dziedziczy po klasie z Devise - RegistrationsController
# Wyzwalamy funkcję "create", która się tam znajduje i rozszerzamy ją.
# Rozszerzamy o "jeżeli są parametry >>:plan<< w adresie URL" to
# Ustaw parametr >:plan< na cechę plan_id elementu >resource<, czyli użykownika
# Jeżeli ktoś wybrał plan 2, czyli PRO, to wywołaj funkcję .save_with_subscription
# Którą to funkcję zaraz utworzymy w MODELU users.rb.
# Jeżeli nie, to zwykły save (plan basic).


class Users::RegistrationsController < Devise::RegistrationsController
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
end
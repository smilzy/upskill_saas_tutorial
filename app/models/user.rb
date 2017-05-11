class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :plan
  has_one :profile
  
  #Definiujemy funkcję opisaną w registrations_controller.
  #Jeżeli dane z formularza się zgadzają - odnieś się do Stripe'a
  #Stwórz tam obiekt Customer i podaje dane klienta
  #Podajemy email i plan_id oraz stripe_card_token, czyli dane karty klienta
  #Zapisane bezpiecznie w Stripe'ie. Zostaje naliczona opłata i stworzona subskrypcja.
  
  #Stripe zwróci informacje, więc zapiszemy je do zmiennej customer.
  
  #Z danych zwróconych przez Stripe interesuje nas token (ID) klienta - customer.id
  #Który jest znany pod nazwą stripe_customer_token, zdefiniowany w naszym pliku DB: schema.rb
  #Wywołujemy go poprzez >self.< czyli samą siebie, czyli w tym przypadku >user.<
  #Customer token odpowiada za naliczanie opłat klientowi.
    #save! - zapisujemy do bazy danych.
  
  
  #Jeszcze dodajemy attr_accessor, aby whitelistować ten zabezpieczony token
  attr_accessor :stripe_card_token
  # If Pro user passes validations (email, password, etc.),
  # then call Stripe and tell it to set up a subscription
  # upon charging the customer's card.
  # Stripe responds back with customer data.
  # Store customer.id as the customer token and save the user.
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end

#Stripe::Customer - możemy się do tego odwoływać dzięki gemowi Stripe

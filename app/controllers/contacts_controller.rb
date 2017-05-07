class ContactsController < ApplicationController
    
    # GET request do /contact-us
    # Pokazuje nowy formularz kontaktowy - name/mail/comm
    def new
        @contact = Contact.new  
    end
    
    # POST request do /contacts - wynika z routingu
    def create
        # Mass assignment - masowe przypisanie pól formularza do obiektu Contact
        @contact = Contact.new(contact_params)
        # Zapisz obiekt Contact do bazy danych
        if @contact.save
            # Zachowaj dane z formularza
            # Store form fields via parameters into variables
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            # Wstaw zmienne (variables) do Contact Mailer,
            # do metody email i wyślij email
            ContactMailer.contact_email(name, email, body).deliver
            # Wiadomość o sukcesie w hashu flash
            # i przenieś do nowej akcji
            flash[:success] = "Message sent."
            redirect_to new_contact_path
        else
            # Jesli obiekt Contact sie nie zapisze,
            # zapisz errory do hasha FLASH
            # i redirectuj do new action
            flash[:danger] = @contact.errors.full_messages.join(", ")
            redirect_to new_contact_path
        end
    end
    
    
    private 
        # Aby zebrać dane z formularza musimy użyć 
        # strong parameters i whitelistować pola formularza.
        # use strong parameters and whitelist the form fields. [Security]
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end

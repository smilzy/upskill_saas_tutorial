class Profile < ActiveRecord::Base
   belongs_to :user 
   has_attached_file :avatar,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
    validates :phone_number, :presence => true,
                             :length => { :minimum =>8, :maximum => 16 },
                             format: { with: /\A(\+\d{1,3}\s)?\(?\d{1,3}\)?[\s.-]?\d{1,3}[\s.-]?\d{1,3}\z/ }
    validates :contact_email, :presence => true, :length => { :minimum => 6 },
                              format: { with: /\A[^@]+@[^@]+\z/ }
end
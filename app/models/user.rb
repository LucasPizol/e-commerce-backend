class User < ApplicationRecord
    has_secure_password

    validates :username, presence: { message: "Username can't be blank" }, uniqueness: { message: "Username already taken" }
    validates :email, presence: { message: "Email can't be blank" }, uniqueness: { message: "Email already taken" }, format: { with: URI::MailTo::EMAIL_REGEXP }
end

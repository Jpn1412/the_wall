require 'bcrypt'
class User < ApplicationRecord

    def self.fetch_user email
        sql_query = ['SELECT * FROM users WHERE email = ?', email]

        result = connection.exec_query(sanitize_sql_array sql_query).first
    end

    def self.register_user params
        sql_query = ['INSERT INTO users (first_name, last_name, email, password, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)',
            params[:first_name],
            params[:last_name],
            params[:email],
            encrypt_password(params[:password]),
            Time.now,
            Time.now
        ]

        user = connection.insert(sanitize_sql_array sql_query)
    end

    def self.validate_registration register_params
        validations = []
        validations << validate_presence(register_params[:first_name], 'First Name')
        validations << validate_presence(register_params[:last_name], 'Last Name')
        validations << validate_presence(register_params[:email], 'Email')
        validations << validate_presence(register_params[:password], 'Password')
        validations << validate_presence(register_params[:confirm_password], 'Confirm Password')
        validations << validate_email_format(register_params[:email])
        validations << validate_password(register_params[:password], register_params[:confirm_password])
        validations << validate_password_length(register_params[:password])
        validations.compact
    end

    def self.authenticate_password(password, entered_password)
        BCrypt::Password.new(password) == entered_password
    end

    def self.validate_presence(attribute, name)
        "#{name} can't be blank" if attribute.nil? || attribute.empty? 
    end

    def self.validate_email_format(attribute)
        "Invalid email format" unless attribute =~ /\A[^@\s]+@[^@\s]+\z/
    end

    def self.validate_password(password, confirm_password)
        "Password doesn't match" if password != confirm_password
    end

    def self.validate_password_length(password)
        "Password chould be at least 8 characters long" if password.length < 8
    end

    def self.encrypt_password(password)
        encrypted_password = BCrypt::Password.create(password)
    end
end

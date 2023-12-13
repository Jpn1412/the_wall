class Message < ApplicationRecord

    def self.insert_message message
        sql_query = ['INSERT INTO messages (user_id, content, created_at, updated_at) VALUES (?, ?, ?, ?)',
            message[:user_id],
            message[:content],
            Time.now,
            Time.now
        ]

        result = connection.insert(sanitize_sql_array sql_query)
    end

    def self.get_message id
        sql_query = ['SELECT * FROM messages WHERE id = ?', id]

        result = connection.exec_query(sanitize_sql_array sql_query).first
    end 

    def self.update_message message
        sql_query = ['UPDATE messages SET content = ?, updated_at = ? WHERE user_id = ?',
            message[:content],
            Time.now,
            message[:user_id]
        ]

        result = connection.update(sanitize_sql_array sql_query)
    end

    def self.validate_message message
        validations = []
        validations << validate_presence(message[:user_id], 'User ID')
        validations << validate_presence(message[:content], 'content')
        validations.compact
    end

    def self.validate_delete message
        sql_query = ['SELECT * FROM messages WHERE id = ? and user_id = ?', message[:message_id], message[:user_id]]

        result = connection.exec_query(sanitize_sql_array sql_query).first
    end

    def self.delete_message message
        sql_query = ['DELETE FROM messages WHERE id = ? and user_id = ?', message[:message_id], message[:user_id]]

        connection.exec_query(sanitize_sql_array sql_query)
    end

    def self.validate_presence(attribute, name)
        "#{name} can't be blank" if attribute.nil? || attribute.empty? 
    end
end

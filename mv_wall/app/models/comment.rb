class Comment < ApplicationRecord

    def self.insert_comment comment
        sql_query = ['INSERT INTO comments (message_id, user_id, content, created_at, updated_at) VALUES (?, ?, ?, ?, ?)',
            comment[:message_id],
            comment[:user_id],
            comment[:content],
            Time.now,
            Time.now
        ]

        result = connection.insert(sanitize_sql_array sql_query)
    end

    def self.get_comment id
        sql_query = ['SELECT * FROM comments WHERE id = ?', id]

        result = connection.exec_query(sanitize_sql_array sql_query).first
    end 

    def self.update_comment comment
        sql_query = ['UPDATE comments SET content = ?, updated_at = ? WHERE user_id = ?',
            comment[:content],
            Time.now,
            comment[:user_id]
        ]

        result = connection.update(sanitize_sql_array sql_query)
    end

    def self.validate_comment comment
        validations = []
        validations << validate_presence(comment[:message_id], 'Message ID')
        validations << validate_presence(comment[:user_id], 'User ID')
        validations << validate_presence(comment[:content], 'content')
        validations.compact
    end

    def self.validate_delete comment
        sql_query = ['SELECT * FROM comments WHERE id = ? and user_id = ?', comment[:comment_id], comment[:user_id]]

        result = connection.exec_query(sanitize_sql_array sql_query).first
    end

    def self.delete_comment comment
        sql_query = ['DELETE FROM comments WHERE id = ? and user_id = ?', comment[:comment_id], comment[:user_id]]

        connection.exec_query(sanitize_sql_array sql_query)
    end

    def self.validate_presence(attribute, name)
        "#{name} can't be blank" if attribute.nil? || attribute.empty? 
    end
end

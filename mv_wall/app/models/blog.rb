class Blog < ApplicationRecord
    def self.get_all
        sql_query = ['
        SELECT  
            messages.id AS message_id,
            messages.content AS message_content,
            messages.updated_at AS message_updated_at,
            users_messages.id AS message_author_id,
            users_messages.first_name AS message_author_first_name,
            users_messages.last_name AS message_author_last_name,
            comments.id AS comment_id,
            comments.content AS comment_content,
            comments.updated_at AS comment_updated_at,
            users_comments.id AS comment_author_id,
            users_comments.first_name AS comment_author_first_name,
            users_comments.last_name AS comment_author_last_name
        FROM
            messages
        LEFT JOIN 
            users AS users_messages ON messages.user_id = users_messages.id    
        LEFT JOIN
            comments ON messages.id = comments.message_id
        LEFT JOIN
            users AS users_comments ON comments.user_id = users_comments.id
        
        ']

        result = connection.exec_query(sanitize_sql_array sql_query)
        structure_data(result)
    end

    def self.structure_data(result)
        messages_with_comments = []
  
        result.each do |row|
            message = messages_with_comments.find { |m| m['message_id'] == row['message_id'] }
    
            unless message
            message = {
                'message_id' => row['message_id'],
                'message_content' => row['message_content'],
                'message_updated_at' => row['message_updated_at'],
                'message_author_id' => row['message_author_id'],
                'message_author_first_name' => row['message_author_first_name'],
                'message_author_last_name' => row['message_author_last_name'],
                'comments' => []
            }
            messages_with_comments << message
            end
    
            if row['comment_id'].present?
            comment = {
                'comment_id' => row['comment_id'],
                'comment_content' => row['comment_content'],
                'comment_updated_at' => row['comment_updated_at'],
                'comment_author_id' => row['comment_author_id'],
                'comment_author_first_name' => row['comment_author_first_name'],
                'comment_author_last_name' => row['comment_author_last_name']
            }
            message['comments'] << comment
            end
        end
    
        messages_with_comments
    end
end
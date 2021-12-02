json.extract! user, :id, :email, :user_type
json.url wallet_url(user, format: :json)

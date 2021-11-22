json.extract! transaction, :id, :description, :origin, :destination, :value, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)

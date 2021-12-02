json.extract! transaction, :id, :description, :origin_id, :destination_id, :value, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)

json.extract! trasanction, :id, :description, :origin, :destination, :value, :created_at, :updated_at
json.url trasanction_url(trasanction, format: :json)

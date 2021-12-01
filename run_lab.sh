export BUNDLE_PATH=".gems"

bundle install
rails db:migrate
rails db:seed
rails s


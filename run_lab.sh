export BUNDLE_PATH=".gems"

echo -e "\n\n\n\ninstall\n\n\n\n"
bundle install
echo -e "\n\n\n\nmigrate\n\n\n\n"
rails db:migrate
echo -e "\n\n\n\nseed\n\n\n\n"
rails db:seed
echo -e "\n\n\n\nrun the server\n\n\n\n"
rails s


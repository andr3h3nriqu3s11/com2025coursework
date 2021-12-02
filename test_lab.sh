export BUNDLE_PATH=".gems"

echo -e "\n\n\n\ninstall\n\n\n\n"
bundle install
echo -e "\n\n\n\nmigrate\n\n\n\n"
rails db:migrate
echo -e "\n\n\n\nrun the test\n\n\n\n"
rails t


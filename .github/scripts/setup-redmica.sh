#!/bin/bash

redmica_branch=$1
database=$2
redmine_dir=$3

cd $redmine_dir

# Replace RedMica code to master branch code
# TODO: これで入れ替えて動かなくなったら独自でDockerfileを書く
if [ $redmica_branch = 'master' ]; then
  set +e
  rm -rf ./* > /dev/null
  rm -rf ./.* 2> /dev/null
  wget --no-check-certificate https://github.com/redmica/redmica/archive/master.tar.gz
  tar -xf master.tar.gz --strip-components=1
  set -e
fi

cp -r $GITHUB_WORKSPACE ./plugins
cp ./plugins/redmica_ui_extension/.github/templates/database-$database.yml config/database.yml
cp ./plugins/redmica_ui_extension/.github/templates/application_system_test_case.rb test/application_system_test_case.rb

# PDFのサムネイル作成テストを成功させるため
sed -i 's/^.*policy.*coder.*none.*PDF.*//' /etc/ImageMagick-6/policy.xml

# DB側のログを表示しないため(additional_environment.rbでログを標準出力に出している)
rm -f ./config/additional_environment.rb

apt update
apt install -y build-essential
bundle install --with test
bundle update
bundle exec rake db:create db:migrate RAILS_ENV=test

# 利用しているRedmineのバージョンなどを確認
RAILS_ENV=test ruby bin/about
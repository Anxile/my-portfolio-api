#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "====== 开始构建过程 ======"

echo "正在安装依赖..."
bundle install

# echo "正在编译资源..."
# bundle exec rake assets:precompile

echo "正在进行数据库操作..."

echo "尝试创建数据库..."
bundle exec rake db:create || echo "数据库可能已存在，继续执行..."

echo "运行数据库迁移..."
bundle exec rake db:migrate

# echo "加载种子数据..."
# bundle exec rake db:seed || echo "种子数据可能已存在，继续执行..."

echo "====== 构建过程完成 ======"
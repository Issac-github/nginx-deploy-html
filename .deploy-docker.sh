#!/usr/bin/env bash

SERVER="root@47.107.49.154"
CONTAINER_NAME="docker-nginx-html-app"
IMAGE_NAME="docker-nginx-html-app"
LOCAL_PORT="3006"
NGINX_PORT="80"
DEPLOY_PATH="/var/www/deployHtmlWithDocker"

echo "run at: `date`"

# 打包项目文件
rm -fr dist.zip
zip -r dist.zip ./dist

ssh ${SERVER} "mkdir ${DEPLOY_PATH};"

# 上传文件到服务器
scp ./dist.zip ${SERVER}:${DEPLOY_PATH}/dist.zip

# 在服务器上执行Docker部署
ssh ${SERVER} "
    # 停止并删除现有容器
    docker stop ${CONTAINER_NAME} 2>/dev/null || true
    docker rm ${CONTAINER_NAME} 2>/dev/null || true
    
    cd ${DEPLOY_PATH}
    # rm -rf ./dist
    # unzip ./dist.zip
    unzip -o ./dist.zip 
    
    # 创建Dockerfile
    cat > Dockerfile << 'EOF'
FROM nginx:latest
COPY dist/ /usr/share/nginx/html/
EXPOSE 80
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF
    
    # 构建Docker镜像
    docker build -t ${IMAGE_NAME} .
    
    # 运行新容器
    docker run -d --name ${CONTAINER_NAME} -p ${LOCAL_PORT}:${NGINX_PORT} ${IMAGE_NAME}
    
    rm -f ./dist.zip
"

# 清理本地文件
rm -fr dist.zip

echo "Docker nginx deploy done"
echo "Application is running at: http://47.107.49.154:${LOCAL_PORT}"
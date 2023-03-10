#!/bin/zsh

# Unset out current status of the Environment Variables
unset MYSQL_ROOT_PASSWORD
unset MYSQL_DATABASE

# Set envrionment variables
export MYSQL_ROOT_PASSWORD=root
export MYSQL_DATABASE=my_app
export VAULT_PORT=8200
export VAULT_TOKEN=root
export VAULT_ADDR=http://localhost:${VAULT_PORT}

# Pull container images
docker pull mysql/mysql-server:5.7
docker pull cloudbrokeraz/app01:latest

# Start MySQL
echo "\n\033[32m---STARTING MYSQL CONTAINER---\033[0m"
if docker inspect "mysql" &> /dev/null; then
  echo "\033[33mContainer MySQL already exists, killing container and redeploying.\033[0m"
  docker rm -f mysql
  sleep 5
  docker volume rm app-data
  sleep 3 
fi
docker run --name mysql --hostname mysql --network demo-network \
  -v app-data:/var/lib/mysql \
  -e "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" \
  -e "MYSQL_DATABASE=$MYSQL_DATABASE" \
  -p 3306:3306 \
  -d mysql/mysql-server:5.7.21
# Sleep required for MySQL to be in a ready state with app-data volume
sleep 15

# Create an application service account 
alias mysql="docker exec -it mysql mysql"
mysql -u root -p'root' -e "CREATE USER 'dbsvc1'@'%' IDENTIFIED BY 'dbsvc1';" &> /dev/null
mysql -u root -p'root' -e "GRANT INSERT,SELECT,UPDATE,DELETE ON my_app.* TO 'dbsvc1'@'%';" &> /dev/null

# Create Vault servcie account for configuration of database secrets engine
mysql -u root -proot -e "CREATE USER 'vaultadmin'@'%' IDENTIFIED BY 'vaultadmin';" &> /dev/null
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'vaultadmin'@'%' WITH GRANT OPTION;" &> /dev/null

# Setup database secrets engine
terraform init
terraform apply -auto-approve

# Start app
echo "\n\033[32m---STARTING TRANSIT APP CONTAINER---\033[0m"
if docker inspect "transit-app" &> /dev/null; then
  echo "\033[33mContainer transit-app already exists, killing container and redeploying.\033[0m"
  docker rm -f transit-app &> /dev/null
  sleep 3
fi
docker run --network demo-network --hostname transit-app --name transit-app \
  -p 5000:5000 \
  -e VAULT_ADDR=http://vault-enterprise:8200 \
  -e VAULT_DATABASE_CREDS_PATH=demo-databases/creds/db-user-readwrite \
  -e VAULT_NAMESPACE= \
  -e VAULT_TOKEN=root \
  -e VAULT_TRANSFORM_PATH=demo-transform \
  -e VAULT_TRANSFORM_MASKING_PATH=masking/transform \
  -e VAULT_TRANSIT_PATH=demo-transit \
  -e MYSQL_ADDR=mysql \
  -d cloudbrokeraz/app01:latest
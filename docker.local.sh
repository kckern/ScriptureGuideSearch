TAG=scripture-guide-search
NAME=sphinxs
docker stop $NAME
docker rm $NAME
docker rmi $TAG:latest
docker rm -f $TAG
source .env
docker build -t $TAG . --build-arg MYSQL_HOST=$MYSQL_HOST --build-arg MYSQL_USER=$MYSQL_USER --build-arg MYSQL_PASS=$MYSQL_PASS --build-arg MYSQL_DB=$MYSQL_DB --build-arg MYSQL_PORT=$MYSQL_PORT
docker run -p 9306:9306  --network kckern  --name $NAME --platform linux/amd64  $TAG 



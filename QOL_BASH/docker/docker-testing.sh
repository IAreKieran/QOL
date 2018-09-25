PROJECT_DIR=`git rev-parse --show-toplevel`

docker container rm -f qol_alpine

cd $PROJECT_DIR
docker build -t qol:alpine -f $PROJECT_DIR/QOL_BASH/docker/dockerfile $PROJECT_DIR
docker run -d -v $PROJECT_DIR:/root/projects/QOL -p 3000:3000/tcp --workdir=/root/projects/QOL/QOL_BASH --name qol_alpine --hostname=qol_alpine qol:alpine

#docker rmi -f $(docker images --filter "dangling=true" -q)

docker exec -it qol_alpine sh -l

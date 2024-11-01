## Comandos

docker build . -t DOCKER_NAME

docker run --interactive --tty --rm --volume $(pwd):/eesc-aero DOCKER_NAME

cd eesc-aero && mkdir build-arm32

cmake -DARM_TARGET=1 ..

make 
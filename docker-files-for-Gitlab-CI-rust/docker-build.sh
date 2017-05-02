#Created by Parity Technologies <devops@parity.io>
#USAGE ./docker-build.sh docker_hub_user docker_hub_password

# Delete all containers
docker rm -f $(docker ps -a -q)
# Delete all images
docker  rmi -f $(docker images -q)
docker login -u $1 -p $2
#make and push rustup image
cd rustup
make image&&make push
cd ..
#make and push rust TOOLCHAIN images
cd rust
make images&&make push
cd ..
#make and push rust stable 14.04.4 image
#cd rust-14.04
#make image&&make push
#cd ..
#make and push javascript image
#cd javascript
#make image&&make push
#cd ..
#make and push rust-test image
cd rust-test
make image&&make push
cd ..
#make and push rust-centos image
cd cross
cd centos
make image&&make push
#make and push rust arm* images
cd ..
cd arm
make image&&make push
cd ..
cd armv6
make image&&make push
cd ..
cd armv7
make image&&make push
cd ..
cd arm64
make image&&make push
cd ..
cd i686
make image&&make push
cd ..
cd debian
make image&&make push
exit

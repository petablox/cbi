# Setup
```sh
. init.sh
```

# Run the small test
```sh
cd small
make
./test
0
run ./test report
```

# Run the large tests
```sh
cd large
./build.sh
build/challenges/HackMan/HackMan < input/HackMan/id:000000,sig:11,src:000129,op:havoc,rep:8
run build/challenges/HackMan/HackMan report
```

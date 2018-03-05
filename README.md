# Setup
Assume: ocaml-3.10.0
```sh
. init.sh
cd boost_1_39_0
./bootstrap.sh
./bjam
cd ../cbiexp-0.6
./conf
make
cd ../sampler-1.6.2
./configure
make
cd ..
```

# Run the small test
```sh
cd small
make
./test
0
run ./test report
# for web interface
cd gen_report
make
# open analysis/summary.xml using Firefox 
```

# Run the large tests
```sh
cd large
./build.sh
build/challenges/HackMan/HackMan < input/HackMan/id:000000,sig:11,src:000129,op:havoc,rep:8
run build/challenges/HackMan/HackMan report
# for web interface
cd gen_report
make
# open analysis/summary.xml using Firefox 
```

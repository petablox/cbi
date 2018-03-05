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
./test [number]    # e.g., ./test 10 that triggers the bug
run ./test report  # print simple cbi report
# for web interface
cd gen_report
make               # run ./test with different arguments in args.txt
# open analysis/summary.xml using Firefox 
```

# Run the large tests
```sh
cd large
make
# for web interface
cd gen_report
make               # run ./jpegtran with different options in options.txt
# open analysis/summary.xml using Firefox 
```

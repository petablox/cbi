TRIAL := 1000
all:
	cp ../jpegtran build/sanity
	./get_site build/sanity 
	rm -rf data
	../../cbiexp-0.6//bin/make-runs $(TRIAL)
	cd analysis && make
clean:
	rm -rf data
	rm -f build/*
	cd analysis && make clean && rm *.txt *.xml && cd ..

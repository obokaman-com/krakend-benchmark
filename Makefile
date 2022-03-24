.PHONY: start stop

TOTAL_REQUESTS := 100000
CONCURRENT_REQUESTS := 500

start:
	docker run -d --rm --name=krakend-benchmark -p 8080:8080 -v ${PWD}/krakend.json:/etc/krakend/krakend.json devopsfaith/krakend:2.0 ; \
	echo "Launching ${TOTAL_REQUESTS} requests to KrakenD - Concurrency: ${CONCURRENT_REQUESTS}" ; \
	sleep 3 ; \
	docker run --rm --net=host  williamyeh/hey -n ${TOTAL_REQUESTS} -c ${CONCURRENT_REQUESTS} http://localhost:8080/test > ${PWD}/results/test_results_krakend_${CONCURRENT_REQUESTS}.txt ; \
	docker stop krakend-benchmark ; \
	cat ${PWD}/results/test_results_krakend_${CONCURRENT_REQUESTS}.txt

stop:
	docker stop krakend-benchmark

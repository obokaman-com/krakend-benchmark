#!/bin/bash

# Initialize variables
TOTAL_REQUESTS=100000
CONCURRENT_REQUESTS=100
PWD=$(pwd)

# Function to check if a command exists
command_exists () {
  type "$1" &> /dev/null ;
}

# Check if krakend exists natively
if command_exists krakend; then
  echo "Running KrakenD natively."
  krakend run -c ${PWD}/krakend.json &> /dev/null &
  KRAKEND_PID=$!
else
  echo "KrakenD not found natively. Running in Docker (performance will be worse)."
  docker run -d --rm --name=krakend-benchmark -p 8080:8080 -v ${PWD}/krakend.json:/etc/krakend/krakend.json devopsfaith/krakend:2.0
fi

# Give some time for KrakenD to start
sleep 1

# Check if hey exists natively
if command_exists hey; then
  echo "Running hey natively."
  hey -n ${TOTAL_REQUESTS} -c ${CONCURRENT_REQUESTS} http://localhost:8080/__health > ${PWD}/results/test_results_krakend_${CONCURRENT_REQUESTS}.txt
else
  echo "Hey command not found natively. Running in Docker (performance will be worse)."
  docker run --rm --net=host williamyeh/hey -n ${TOTAL_REQUESTS} -c ${CONCURRENT_REQUESTS} http://localhost:8080/__health > ${PWD}/results/test_results_krakend_${CONCURRENT_REQUESTS}.txt
fi

# Stop KrakenD
if [ -n "$KRAKEND_PID" ]; then
  kill $KRAKEND_PID
else
  docker stop krakend-benchmark
fi

# Display the results
cat ${PWD}/results/test_results_krakend_${CONCURRENT_REQUESTS}.txt

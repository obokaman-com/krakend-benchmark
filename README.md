# Simple KrakenD API Gateway benchmarking

Simple performance test using `hey` to launch 100K requests with 100 concurrent calls to the health endpoint from the gateway itself.

The requests number and the concurrency can be defined in the `execute_benchmark.sh` file.

KrakenD and even `hey` will try to run natively. If they're not found locally, it will use Docker, so the results may vary depending on the host machine and OS (remember that MacOS uses a virtual machine to run Docker).

Results are being saved in the `results` folder.

### Execute performance tests

```shell
$ ./execute_benchmark.sh
```

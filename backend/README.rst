Backend
=======

Running
-------

> ./app.py

Responds to -h.  Host, port and CSV-file path can be configured.


API Usage examples
------------------

> curl http://localhost:8080/v1/pois.json
> curl http://localhost:8080/v1/pois.json?category=tulipaikka
> curl http://localhost:8080/v1/pois.json?category=tulipaikka&category=museo
> curl http://localhost:8080/v1/pois.json?categories=museo,tulipaikka

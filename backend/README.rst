Backend
=======

Environment setup
-----------------
This is required for Osuma API use, not for the old curated_sights.csv data
set.  Only required library outside of CPython is the requests HTTP client
library <http://docs.python-requests.org/en/latest/>.

::

    virtualenv env
    source env/bin/activate
    pip install -r requirements.txt

Running
-------

::
    
    source env/bin/activate
    ./app.py

Responds to -h.  Host, port and CSV-file path can be configured.


API Usage examples
------------------

::
    
    curl http://localhost:8080/v1/pois.json
    curl http://localhost:8080/v1/pois.json?category=tulipaikka
    curl http://localhost:8080/v1/pois.json?category=tulipaikka&category=museo
    curl http://localhost:8080/v1/pois.json?categories=museo,tulipaikka

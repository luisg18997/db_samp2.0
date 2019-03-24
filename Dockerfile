FROM postgres:9.6
COPY locale.gen /etc/
RUN locale-gen
COPY *.sql /docker-entrypoint-initdb.d/
RUN ls -l /docker-entrypoint-initdb.d/ 

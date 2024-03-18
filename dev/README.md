# Development

### Containerised Development environment

First run gradle to build the app and create the war if you haven't already.

    cd ../kbplus/
    ./gradlew clean build -x integrationTest -x Test

To run the full stack and bootstrap mysql and elasticsearch

    docker-compose -f docker-compose-dev-setup.yml -f docker-compose-dev-app.yml -f docker-compose-dev-bootstrap.yml up

kbplus will be available at http://localhost:8080/kbplus/

To just run the datastores for local dev

    docker-compose -f docker-compose-dev-setup.yml

To run the optional dev tools like Application performance monitoring and Kibana dashboards

    docker-compose -f docker-compose-dev-setup.yml -f docker-compose-dev-app.yml -f docker-compose-dev-tools.yml up

kibana will be available at http://localhost:5601/

`docker-compose-dev-bootstrap.yml` only needs to be ran on first boot or when elasticsearch mappings change.


### Database Administration

To use the mysql command line client, you will need to use 

    mysql -u root -h 127.0.0.1 -P 3306 -p

-h localhost will likely fail as the client will try and use a socket instead of tcp. Set up your databases as described in the root readme.md

Alternatively, run mysql client in the container or when using mariadb fire up a new client container.

mysql
    
    docker exec -it jc_mysql mysql -u root -p

mariadb

    docker run -it --network dev_default --rm mariadb:11 mariadb -hjc_mysql -uroot -p

Load a dump file stored on the container

    cat backup.sql | docker exec -i jc_mysql mysql -u root --password=jc kbplus700prod

Or 

    cat backup.sql | docker exec -i jc_mysql mysql -u root --password=jc kbplus700dev



To use the mysql command line client, you will need to use 

mysql -u root -h 127.0.0.1 -P 3306 -p

-h localhost will likely fail as the client will try and use a socket instead of tcp. Set up your databases as described in the root readme.md

Alternatively, run mysql client in the container

docker exec -it jc_mysql mysql -u root -p

Load a dump file storred on the container

cat backup.sql | docker exec -i jc_mysql mysql -u root --password=jc kbplus700prod


Frontend-api
============
Java Web Application that handles requests from the frontend.

Starting Locally
----------------
* To packaging application you need to have Maven and Java installed on your computer. After installing those navigate with your terminal and type the following command:
```
$ mvn clean install
```
* After all dependencies are resolved execute the next command:
```
$ mvn spring-boot-run 
```

Docker Delivery
---------------
#### Build & Push
Build and upload docker image for production. This build our application into jar file and serve it using a web server.
```
$ ./docker-push 
```

#### Pull & Run
Pull image and run docker container.
```
$ ./docker-run 
```

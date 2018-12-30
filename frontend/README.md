Frontend
========
Nginx web server that serves our ReactJS static files.

Starting Locally
----------------
* To start the React application you need to have NodeJS and NPM installed on your computer. After installing those navigate with your terminal and type the following command:
```
$ npm install
```
* After all dependencies are resolved execute the next command:
```
$ npm start 
```

Docker Delivery
---------------
#### Build & Push
Build and upload docker image for production. This build our application into static files and serve them using a web server.
```
$ ./docker-push 
```

#### Pull & Run
Pull image and run docker container.
```
$ ./docker-run 
```

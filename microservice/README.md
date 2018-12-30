Microservice
============
Python application that performs Sentiment Analysis.

Starting Locally
----------------
* To start the React application you need to have pip3 and python3 on your computer. After installing those navigate with your terminal and type the following command:
```
$ pip3 install -r requirements.txt && python3 -m textblob.download_corpora
```
* After all dependencies are resolved execute the next command:
```
$ python3 sentiment_analysis.py 
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

docker build -t srvr .
docker run -it --rm -p 21:21 -p 21000:21000 srvr

# Flickake

Self-hosted movie library like Netflix, can be used with simple configuraion and little setting.

![Demo](https://res.cloudinary.com/juntaki/image/upload/v1510982247/flickake_demo.webp)

## How to use

### Deploy with Docker

Just specify path to your movie library directory.
Your flickake will deployed to http://hostname:3000/

~~~
docker pull juntaki/flickake
docker run -d --name=flickake -p 3000:3000 \
           -e SECRET_KEY_BASE=YOUR_SECRET \
           -v /path/to/movie_library:/app/files juntaki/flickake \
           -v /path/to/log:/app/log
~~~

### Scan / Rescan movies in the library

Click "Scan" in navigation bar.

or run the following command-line.

~~~
docker exec flickake rails movies:scan  
~~~

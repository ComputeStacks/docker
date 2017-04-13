# Laravel 5 Docker Container

Based on the [Bitnami Laravel Container](https://github.com/bitnami/bitnami-docker-laravel). This image contains a few differences:

  - Resolves a permissions issue that prevented the sample Laravel app from being installed, which caused the container to not boot
  - Changed how the container checks for it's MySQL connection. It no longer uses 'docker links', and instead will look for the MySQL environmental variable.
  - This image will create the database if it does not already exist. Additionally, it will not run php artisan migrate by default if the database exists. 

# Example

docker run -d --name laravel \
           -e DB_HOST=172.17.0.1 \
           -e DB_USERNAME=root \
           -e DB_PASSWORD=Am40PNvT4 \
           -e DB_DATABASE=laravel \
           -p 3000:3000 \
           laravel

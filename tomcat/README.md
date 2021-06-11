# Tomcat

This image uses the bitnami tomcat image, however we made a change that allows creating directories and uploading war files to the root app directory.

Video demo's using this image: https://drive.google.com/drive/folders/1XYZr1blf2CuZQtL4kkejQsSFSeB5tPkM?usp=sharing

## Deploying a single app

1. Rename your `war` file to `ROOT.war`
2. Delete the existing `ROOT` directory: `/home/sftpuser/apps/<service-name>/tomcat/data/ROOT/`
3. Upload your `war` file to `/home/sftpuser/apps/<service-name>/tomcat/data/`
4. Wait a few seconds and you should see a new `ROOT` directory with the contents of your `war` file, and your app should now be accessible on the container service's domain.

## Deploying additional applications

1. Name your `war` file to something unique, such as `myapp`.
2. Upload your `war` file to `/home/sftpuser/apps/<service-name>/tomcat/data`
3. Your app will be accessible at `https://<your-domain>/filename` or `/<context>` if you specified that.

### Use Host Manager to configure multiple apps

1. Enable host manager by editing the environment variables for your service and setting `TOMCAT_ALLOW_REMOTE_MANAGEMENT` to `1`
2. Rebuild your container
3. Access at `/host-manager`. Username will be `user` and password will be displayed under the settings section of your service

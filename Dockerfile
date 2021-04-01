FROM httpd:2.4
ARG buildNumber
COPY index.html /usr/local/apache2/htdocs/
LABEL jobName=$buildNumber

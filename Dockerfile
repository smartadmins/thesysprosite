FROM httpd:2.4.66
COPY . /usr/local/apache2/htdocs/
EXPOSE 80


FROM phusion/baseimage:0.9.16
MAINTAINER Neil Ellis hello@neilellis.me
VOLUME /data
EXPOSE 80

CMD ["/sbin/my_init"]

ENV HOME /root
WORKDIR /root

RUN adduser --disabled-password --gecos '' app

RUN sudo apt-get install curl apache2 php5 php5-common php5-cli php5-curl php5-json php5-mcrypt php5-gd php5-mysql mysql-server mysql-client git
RUN echo "create database dreamfactory" | mysql 
RUN echo "grant all privileges on dreamfactory.* to 'dsp_user'@'localhost' identified by 'dsp_user';" | mysql
RUN pecl install mongo
RUN mkdir -p /home/app/dreamfactory/platform
RUN chmod 777 /home/app/dreamfactory/platform
RUN git clone https://github.com/dreamfactorysoftware/dsp-core.git /home/app/dreamfactory/platform
RUN cd /opt/dreamfactory/platform && ./scripts/installer.sh –cv
RUN chmod 775 /home/app/dreamfactory/platform/web/assets/
RUN a2enmod rewrite
RUN php5enmod mcrypt
RUN cat /etc/apache2/sites-available/default
COPY default.conf /etc/apache2/sites-available/default

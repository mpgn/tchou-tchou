FROM ruby:2.5.8-stretch
RUN echo "deb http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y curl && apt-get install -y nodejs && apt-get install -y vim && apt-get install -y cron && apt install -y supervisor
RUN useradd --home-dir /home/demoniac --create-home --uid 5000 demoniac
RUN mkdir /home/demoniac/myapp
WORKDIR /home/demoniac/myapp
COPY demo-5.2.1 /home/demoniac/myapp
RUN chown -R demoniac:demoniac /home/demoniac/
RUN mkdir /home/demoniac/ran0dom0_directoy_126
COPY flag.txt /home/demoniac/ran0dom0_directoy_126/flag.txt
RUN chmod 777 /home/demoniac/ran0dom0_directoy_126/flag.txt
RUN mkdir /home/demoniac/script
COPY restart.sh /home/demoniac/script/restart.sh
RUN chmod +x /home/demoniac/script/restart.sh

USER demoniac

COPY rails-cron /home/demoniac/rails-cron
RUN crontab /home/demoniac/rails-cron
RUN bundle update mimemagic
RUN bundle install
RUN rm config/credentials.yml.enc && EDITOR='vi -N -u NONE -n -c "wq"' rails credentials:edit

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3000

USER root

CMD ["/usr/bin/supervisord", "-n"]

HEALTHCHECK --interval=30s --timeout=3s \
	CMD curl -f http://localhost:3000/demo || exit 1

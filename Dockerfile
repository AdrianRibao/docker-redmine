FROM ubuntu:13.10
MAINTAINER sameer@damagehead.com

env DEBIAN_FRONTEND noninteractive

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update # 20140402

# essentials
RUN apt-get install -y vim curl wget sudo net-tools pwgen && \
	apt-get install -y logrotate supervisor openssh-server && \
	apt-get clean

# build tools
RUN apt-get install -y gcc make && apt-get clean

RUN apt-get install -y unzip imagemagick sqlite3 \
      memcached subversion git cvs bzr && apt-get clean

RUN apt-get install -y libcurl4-openssl-dev libssl-dev \
      libapr1-dev libaprutil1-dev \
      libmagickcore-dev libmagickwand-dev libmysqlclient-dev \
      libxslt1-dev libffi-dev libyaml-dev zlib1g-dev libzlib-ruby && apt-get clean

RUN apt-get install -y ruby ruby-dev ruby-mysql2 ruby-sqlite3 bundler && apt-get clean

#RUN gem install --no-ri --no-rdoc bundler mysql2
#RUN gem install --no-ri --no-rdoc bundler sqlite3
RUN gem install --no-ri --no-rdoc bundler activerecord-postgresql-adapter

ADD assets/ /redmine/
RUN chmod 755 /redmine/init /redmine/setup/install && /redmine/setup/install

RUN gem install --no-ri --no-rdoc unicorn

ADD authorized_keys /root/.ssh/
RUN mv /redmine/.vimrc /redmine/.bash_aliases /root/
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys && chown root:root -R /root

EXPOSE 80

ENTRYPOINT ["/redmine/init"]
CMD ["app:start"]

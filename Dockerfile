# Customized Owasp ZAP Dockerfile with support for authentication

FROM owasp/zap2docker-weekly
LABEL maintainer="Dick Snel <dick.snel@ictu.nl>"

USER root

# Adding trusting keys to apt for repositories
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# Adding Google Chrome to the repositories
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# install GoogleChrome & Chrome Driver
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS http://chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
ENV DISPLAY=:99

RUN mkdir /zap/wrk \
	&& cd /opt \
	&& wget -qO- -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz \
	&& tar -xvzf geckodriver.tar.gz \
	&& chmod +x geckodriver \
	&& ln -s /opt/geckodriver /usr/bin/geckodriver \
	&& export PATH=$PATH:/usr/bin/geckodriver

ADD . /zap/

ADD scripts /home/zap/.ZAP_D/scripts/scripts/active/
RUN chmod 777 /home/zap/.ZAP_D/scripts/scripts/active/

RUN pip install -r /zap/requirements.txt \
	&& chown -R zap:zap /zap/ \
	&& chmod +x /zap/zap-baseline-custom.py

USER zap

VOLUME /zap/wrk
WORKDIR /zap

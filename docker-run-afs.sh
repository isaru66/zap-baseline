#-d enable debug
docker run --name owasp-afs --rm -v $(pwd):/zap/wrk/:rw -p 8090:8090 -t isaru66/zap2docker-weekly:afs zap-full-scan.py -I -j -m 5 -T 10 \
  -d \
  -t https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter \
  -P 8090 \
  -r testreport-afs.html \
   --hook=/zap/auth_hook.py \
  -z " 'auth.loginurl=https://iot-apivr.ais.co.th/auth/v3.1/oauth/authorize?response_type=code&client_id=akkvxcDk42zwR6Zp0lGplzP1nLqJqNqVrPBufJj%2FzWg%3D&scope=profile&redirect_uri=https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/auth' \
      auth.username=Thawatkl \
      auth.password=Tha@2021 \
      auth.username_field=username \
      auth.password_field=password \
      auth.submit_field=submit \
      auth.include='https://dev-aftersale-portal.cdc.ais.th/*,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-menu'  \
      auth.exclude='.*logout.*,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/logout' \
      api.addrs.addr.name=.* \
      api.addrs.addr.regex=true \
      api.key=zapapikey \
      "
      
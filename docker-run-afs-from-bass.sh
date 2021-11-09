#-d enable debug
docker run --name owasp-afs --rm -v $(pwd):/zap/wrk/:rw -p 8090:8090 -t isaru66/zap2docker-weekly:afs zap-full-scan.py -I -j -m 5 -T 10 \
  -d \
  -t https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-menu \
  -P 8090 \
  -r testreport18_test.html \
   --hook=/zap/auth_hook.py \
  -z "auth.loginurl=https://iot-apivr.ais.co.th/auth/v3.1/oauth/authorize?response_type=code&client_id=akkvxcDk42zwR6Zp0lGplzP1nLqJqNqVrPBufJj%2FzWg%3D&scope=profile&redirect_uri=https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/auth\
      auth.username=Thawatkl \
      auth.password=Tha@2021 \
      auth.username_field=susername \
      auth.password_field=spassword \
      auth.submit_field=bsing_in \
      auth.include=‘https://dev-aftersale-portal.cdc.ais.th.*’ \
      auth.exclude=‘.*iot-apivr.*,.*google.*,.*gstatic.*,.*firefox.*,.*mozilla.*’ \
      api.addrs.addr.name=.* \
      api.addrs.addr.regex=true \
      api.disablekey=true \
      explore.urls=‘https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-menu,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/main-dashboard,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/search,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/check-stock,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/eclaim-dashboard,https://dev-aftersale-portal.cdc.ais.th/aftersale/afscenter/user-permission’ \
      proxy.host=‘127.0.0.1’ \
      proxy.port=8090 \
      "
      
FROM nginx:mainline

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

RUN chmod 777 /etc/nginx/conf.d/default.conf

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8082;/' /etc/nginx/conf.d/default.conf
EXPOSE 8082

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN sed -i "/#tcp_nopush/i server {\nlisten 8080;\nlisten [::]:8082; \naccess_log /var/log/nginx/reverse-access.log;\n error_log /var/log/nginx/reverse-error.log;\nlocation / {\n proxy_pass http://activemq-sbcp-async-messaging.apps.ocp4.innershift.sodigital.io;\n}\n}" /etc/nginx/nginx.conf

RUN addgroup nginx root

USER nginx

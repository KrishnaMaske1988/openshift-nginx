FROM nginx:mainline

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN sed -i "/#tcp_nopush/i server {\nlisten 80;\nlisten [::]:8081; \naccess_log /var/log/nginx/reverse-access.log;\n error_log /var/log/nginx/reverse-error.log;\nlocation / {\n proxy_pass http://api.ocp4.innershift.sodigital.io:8080;\n}\n}" /etc/nginx/nginx.conf

RUN addgroup nginx root

USER nginx

CMD ["nginx", "-g", "daemon off;"]
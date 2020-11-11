FROM alpine:3.2
RUN apk add --update nginx && rm -rf /var/cache/apk/*
RUN mkdir -p /tmp/nginx/client-body

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN sed -i "/#tcp_nopush/i server {\nlisten [::]:8081; \naccess_log /var/log/nginx/reverse-access.log;\n error_log /var/log/nginx/reverse-error.log;\nlocation / {\n proxy_pass http://api.ocp4.innershift.sodigital.io:8080;\n}\n}" /etc/nginx/nginx.conf
COPY website /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
# For Debian
ARG DEBIAN_VERSION=buster
FROM debian:${DEBIAN_VERSION} AS debian-plus


# Download certificate and key from the customer portal (https://my.f5.com)
# and copy to the build context:
COPY nginx-repo.crt nginx-repo.key /etc/ssl/nginx/

# Install prerequisite packages:
RUN apt-get update && apt-get -y install apt-transport-https lsb-release ca-certificates wget gnupg2
RUN wget https://cs.nginx.com/static/keys/nginx_signing.key && apt-key add nginx_signing.key
RUN wget https://cs.nginx.com/static/keys/app-protect-security-updates.key && apt-key add app-protect-security-updates.key
RUN wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key

# Add NGINX Plus repo to apt
RUN printf "deb https://pkgs.nginx.com/plus/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list
RUN printf "deb https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | tee -a /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb https://pkgs.nginx.com/app-protect-dos/debian `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect-dos.list
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Install NGINX all modules
RUN apt-get -y update
RUN apt-get install -y nginx-plus \
                       app-protect app-protect-attack-signatures \
                       app-protect-dos \
                       nginx-plus-module-njs \
                       nginx-plus-module-lua \
                       && apt-get clean &&  rm -rf /etc/ssl/nginx

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf /etc/nginx/
COPY entrypoint.sh  /root/

CMD ["sh", "/root/entrypoint.sh"]

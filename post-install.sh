# /bin/bash
# A "poor man's configuration management":
# A script to setup Nginx and PHP and configure a simple
# php "app" that shows the server's ip address
# https://sldn.softlayer.com/blog/jarteche/Getting-Started-User-Data-and-Post-Provisioning-Scripts

# update packages
apt-get update -y
# install nginx and php
apt-get install --yes nginx php-fpm
# configure nginx to serve php
cat > /etc/nginx/sites-available/default <<EOL
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  root /var/www/html;
  index index.php index.html index.htm;
  server_name _;
  location / {
	   try_files $uri $uri/ =404;
  }
	location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.0-fpm.sock;
  }
}
EOL
# update the deafult index.html to show the server's ip address
cat > /var/www/html/index.php <<EOL
<!DOCTYPE html>
<html>
<head>
<title>Schematics Hello World</title>
<style>
body {
  margin: 0px;
  font: 20px 'RobotoRegular', Arial, sans-serif;
  font-weight: 100;
  height: 100%;
  color: #0f1419;
}
div.info {
  display: table;
  background: #e8eaec;
  padding: 20px 20px 20px 20px;
  border: 1px dashed black;
  border-radius: 10px;
  margin: 0px auto auto auto;
}
div.info p {
    display: table-row;
    margin: 5px auto auto auto;
}
div.info p span {
    display: table-cell;
    padding: 10px;
}
img {
    width: 176px;
    margin: 36px auto 36px auto;
    display:block;
}
div.smaller p span {
    color: #3D5266;
}
h1, h2 {
  font-weight: 100;
}
div.check {
    padding: 0px 0px 0px 0px;
    display: table;
    margin: 36px auto auto auto;
    font: 12px 'RobotoRegular', Arial, sans-serif;
}
#footer {
    position: fixed;
    bottom: 36px;
    width: 100%;
}
#center {
    width: 400px;
    margin: 0 auto;
    font: 12px Courier;
}

</style>
</head>
<body>
<img alt="NGINX Logo" src="data:image/png;base64,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"/>
<div class="info">
  <p>
    <span>
      Server&nbsp;IP:
    </span>
    <span>
      <?php
        echo $_SERVER['SERVER_ADDR'];
      ?>
    </span>
  </p>
</div>
</body>
</html>
EOL
# restart nginx for good effect
service nginx restart

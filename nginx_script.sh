#!/bin/bash

dnf update -y
dnf install -y nginx

systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html <<EOF
  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
      <title>Zero Carb</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="./style.css">
    </head>
    <body>
      <header><a href="index.html" class="visited-link">Zero Carb</a></header>
      <hr>
      <h2>About me</h2>
      <p>
        Zero Carb, psoriasis and life with purpose.
      </p>
    </body>
  </html>
EOF
  
chmod -R 755 /usr/share/nginx/html
chown -R nginx:nginx /usr/share/nginx/html

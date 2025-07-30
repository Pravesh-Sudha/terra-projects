#!/bin/bash

# Install NGINX
apt update -y
apt install nginx -y

# Start NGINX service
systemctl enable nginx
systemctl start nginx

# Portfolio HTML
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Pravesh Sudha | Portfolio</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      text-align: center;
      padding: 50px;
    }
    h1 { color: #333; }
    p  { font-size: 18px; color: #666; }
    a  { color: #007BFF; text-decoration: none; }
  </style>
</head>
<body>
  <h1>Hi, I'm Pravesh Sudha</h1>
  <p>DevOps · Cloud · Content Creator</p>
  <p>
    <a href="https://blog.praveshsudha.com" target="_blank">Blog</a> |
    <a href="https://x.com/praveshstwt" target="_blank">Twitter</a> |
    <a href="https://www.youtube.com/@pravesh-sudha" target="_blank">YouTube</a> |
    <a href="https://www.linkedin.com/in/pravesh-sudha/" target="_blank">LinkedIn</a>
  </p>
</body>
</html>
EOF


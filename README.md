# nginx-deploy-html

deploy html with nginx

sudo nano /etc/nginx/sites-available/only_html

```
server {
        listen 3001;
        server_name onlyHtml.com;

        root /var/www/onlyHtmlDir/dist;
        index index.html;

        location / {
                try_files $uri $uri/ =404;
        }
}

server {
    listen 3002;
    server_name localhost;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

ctrl + o then enter then ctrl + x

sudo ln -s /etc/nginx/sites-available/only_html /etc/nginx/sites-enabled/

sudo systemctl reload nginx

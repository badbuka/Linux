# Nginx
## Caching
### 1. Configure cache path
```
proxy_cache_path /var/nginx_cache/gryzli.info levels=1:2 keys_zone=gryzli.info:2m max_size=256m inactive=12h use_temp_path=off;
``` 
This is what our proxy_cache_path says:
* Store cache files inside /var/nginx_cache/gryzli.info
* Use 2 level directory structure (levels=1:2)
* Make the name of this cache object: gryzli.info
* Use 2m in memory for cache key mappings (2m is about 2 000 cache objects)
* Limit the size of cache directory to “max_size=256m”
* Delete cache files if they are not used for “inactive=12h“
* Don’t use custom path for temporary cache files (use_temp_path=off)

### 2. Configure good proxy_cache_key

The problem here is that there is no “$host” in the default key.
This means, that if you have Redirect 301 from domain.com to www.domain.com, and you have the chance to first hit non-www domain, you will always receive 301 redirect from Nginx caching, causing redirect loop.
In order to fix this misbehavior, you need to add at least the following proxy_cache_key:

```
proxy_cache_key $scheme$host$proxy_host$request_uri;
```
### 3. Configuring some important headers
Here the most important one is : 
```
proxy_set_header Host $host;
```
By setting the Host header, we are telling upstream/backend server (in our case Apache), which exact vhost it should access to return the content.
```
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Host $host;
proxy_set_header X-Forwarded-Proto $scheme;
```
### 4. Caching based on page size

One way to do the conditional caching is by using map {} to check the size of the page received by your upstream and define certain limits (by using regex), for which you set option that controls whether the request to be cached or not.

Here is some simple configuration, which disables caching for pages bigger than 5,99Megabytes.

The first thing is to define your map clause, inside http clause, where you actually make the size comparison with regex:
```
http {
...
# Don't cache files bigger than 5,999,999 bytes
map $upstream_http_content_length $request_too_large {
  default                 0;
  "~^[1-5]?[0-9]{0,6}$"   0;
  "~^[1-5]?[0-9]{7,}$"    1;
                }
...
}
```
Now we should define inside our caching Location {} , that we don’t want to cache requests, which have $request_too_large set to 1.
```
ocation "/" { 
...
    proxy_no_cache $request_too_large;
...
} 
```

### 5. Don't cache when user have a coockie
This is a goo idea to do not cache when user have a coockie, because of personalization or authorization
```
{
...
  if ($http_cookie ~* ".+" ) {
  set $do_not_cache 1;
    }
  proxy_cache_bypass $do_not_cache;
...
}
```

## Example
```
server {
        listen 80;

        location / {
                if ($http_cookie ~* ".+" ) {
                        set $do_not_cache 1;
                }
                proxy_cache_bypass $do_not_cache;
                proxy_pass http://127.0.0.1:81/;
                proxy_cache all;
                proxy_cache_valid 404 502 503 1m;
                proxy_cache_valid any 1h;
        }
}
```
## Fastcgi example
In http section of nginx.conf
```
fastcgi_cache_path /var/cache/fpm levels=1:2 keys_zone=fcgi:32m max_size=1g;
fastcgi_cache_key "$scheme$request_method$host$request_uri";
```
In host configuration
```
server {
    listen   80;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_cache fcgi;
        fastcgi_cache_valid 200 60m;
    }
}
```

# le-dns-docker - Automatic let's encrypt DNS challenge (AWS, Cloudflare, Selectel) with docker containers


## How to use

- get conf/config.json and change things
    - set base dir for all files (docker by default).
    - set Api provider: "aws" or "cloudflare" or "selectel". (https://aws.amazon.com/ or https://www.cloudflare.com or https://selectel.ru)
    - set Api key for DNS api 
    - set email
    - set domain for docker registry service 

- run init.py (Python 3)


- Don't work now:
1) aws
2) auto renew certs
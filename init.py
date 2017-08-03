import os
import json

with open("conf/config.json") as config_file:
    config = json.load(config_file)

basedir = config["basedir"]
api_type = config["api_type"]
domain = config["domain"]
email = config["email"]

# Check dir and change it(if need) to full path
if basedir[0] != "/":
    basedir = os.getcwd() + "/" + basedir
if basedir[-1] == "/":
    basedir = basedir[:-1]

# Create dir for project files
os.makedirs(basedir + "/certs", mode=0o740, exist_ok=True)


# Init certificate generation:
if api_type not in ["aws", "cloudflare", "selectel"]:
    raise Exception("Api_type error")

# Prepare docker and certbot command
docker_command = "docker run " \
                 "--rm " \
                 "-v {0}:/tmp/scripts " \
                 "-v {1}:/tmp/conf " \
                 "-v {2}:/etc/letsencrypt/ " \
                 "soshnikov/certbot ".format(os.getcwd() + "/" + api_type,
                                             os.getcwd() + "/conf",
                                             basedir + "/certs")

certbot_command = "certonly " \
                  "--manual" \
                  " --preferred-challenges=dns " \
                  "--agree-tos " \
                  "--manual-public-ip-logging-ok " \
                  "-n " \
                  "--manual-auth-hook /tmp/scripts/authenticator.sh " \
                  "--manual-cleanup-hook /tmp/scripts/cleanup.sh " \
                  "--email {0} " \
                  "-d {1}".format(email, domain)

# Run docker + certbot
os.system(docker_command+certbot_command)

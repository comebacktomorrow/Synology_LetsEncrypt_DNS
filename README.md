# Synology_LetsEncrypt_DNS
A script to copy SSL certs from a Docker instance.

It's defifintely overkill. It was written in such a way that it could copy certificates for multiple domains to multiple destinations, figuring out what goes where by comparing CNAME of source and destination certificate.

There's also a secodary script that's run upon Rackstation\Diskstation reboot.

I currently use https://github.com/csmith/docker-letsencrypt-lexicon to get the certificates

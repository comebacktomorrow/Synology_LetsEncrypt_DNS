# Synology_LetsEncrypt_DNS
A script to copy SSL certs from a Docker instance.

It's defifintely overkill. It was written in such a way that it could copy certificates for multiple domains to multiple destinations, figuring out what goes where by comparing CNAME of source and destination certificate.

There's also a secodary script that's run upon Rackstation\Diskstation reboot.

I currently use https://github.com/csmith/docker-letsencrypt-lexicon to get the certificates.

The major issue is that the system replaces the certificates on reboot with stock ones meaning that the CNAME's end up mismatching causing the script to fail.

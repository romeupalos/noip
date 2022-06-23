NoIP
======

![Build Status](https://github.com/romeupalos/noip/actions/workflows/docker-image/badge.svg)
[![License](https://img.shields.io/github/license/romeupalos/noip.svg)](LICENSE)

[![Docker Pulls](https://img.shields.io/docker/pulls/romeupalos/noip.svg)](https://hub.docker.com/r/romeupalos/noip)
[![Docker Stars](https://img.shields.io/docker/stars/romeupalos/noip.svg)](https://hub.docker.com/r/romeupalos/noip)

## Useful links
* [Docker Hub](https://hub.docker.com/r/romeupalos/noip)
* [GitHub](https://github.com/romeupalos/noip)

## What is NoIP?

NoIP is a dynamic DNS service. You can access your dynamic IP address machines with the service. [Know more](https://www.noip.com)

There is client to update the dynamic DNS IP called DUC (Dynamic Update Client).

From DUC [Download page](https://www.noip.com/download):

> Our Dynamic DNS Update Client continually checks for IP address changes in the background and automatically updates the DNS at No-IP whenever it changes.
>
> ✔ Command Line Interface
>
> ✔ Quick & Easy Setup
>
> ✔ Widely Compatible
>
> ✔ Auto Host List Download
>
> ✔ Runs When Logged Out
>
> ✔ Open Source

## About This Image

This is multi architecture docker image for the [NoIP](https://www.noip.com) DUC (Dynamic Update Client)

### Supported Architectures
 * arm32v6
 * arm64v8
 * amd64
 * i386
 * s390x
 * ppc64le

## Getting Started

### Creating the configuration file
In order to create the configuration file (i.e. `no-ip2.conf`), run the following command
```
docker run -it --rm \
  -v $(pwd):/usr/local/etc:rw \
  romeupalos/noip -C
```
An interactive wizard will ask every necessary information and it will generate the configuration file

### Running

#### Using a configuration file (recommended)
```
docker run -d \
  -v $(pwd)/no-ip2.conf:/usr/local/etc/no-ip2.conf:rw \
  romeupalos/noip -d
```

#### Using noip2 command line

Program usage from noip2 help:

```
USAGE: noip2 [ -C [ -F][ -Y][ -U #min]
	[ -u username][ -p password][ -x progname]]
	[ -c file][ -d][ -D pid][ -i addr][ -S][ -M][ -h]

Version Linux-2.1.9
Options: -C               create configuration data
         -F               force NAT off
         -Y               select all hosts/groups
         -U minutes       set update interval
         -u username      use supplied username
         -p password      use supplied password
         -x executable    use supplied executable
         -c config_file   use alternate data path
         -d               increase debug verbosity
         -D processID     toggle debug flag for PID
         -i IPaddress     use supplied address
         -I interface     use supplied interface
         -S               show configuration data
         -M               permit multiple instances
         -K processID     terminate instance PID
         -z               activate shm dump code
         -h               help (this text)
```

Example
```
docker run -d \
  -v $(pwd)/no-ip2.conf:/usr/local/etc/no-ip2.conf:rw \
  romeupalos/noip -d \
  -u <username> \
  -p <password> \
  -U [time-interval]
```

## Donate
If you like this image, or if it helped you in any way, you could give me a cup of coffee :)


[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9VEGSAE5YFDT6&source=url)

## Author
Romeu Palos de Gouvêa [romeupalos@gmail.com](mailto:romeupalos@gmail.com)

## License
MIT

FROM ubuntu:latest
COPY ttaspath.sh .
RUN apt-get update && apt-get install -y curl traceroute whois
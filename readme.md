# ttaspath

Run tcp traceroute to port 443 and print ip AS path.

### Run

```
curl https://raw.githubusercontent.com/M1ndas/ttaspath/refs/heads/main/ttaspath.sh -s | bash -s cnn.com
1 | NA      | 172.31.1.1       | NA
2 | 24940   | 65.108.114.130   | HETZNER-AS, DE
3 | 24940   | 88.198.29.141    | HETZNER-AS, DE
4 | 24940   | 213.239.228.9    | HETZNER-AS, DE
5 | 24940   | 213.239.252.70   | HETZNER-AS, DE
6 | 54113   | 151.101.3.5      | FASTLY, US
```

or

```
./ttaspath cnn.com
```

### Testing after changes

```
bnr
```

### Examples

Cloudflare DNS server has fewer hops compare to google dns:
```
root@s1:~# curl https://raw.githubusercontent.com/M1ndas/ttaspath/refs/heads/main/ttaspath.sh -s | bash -s 1.1.1.1
1 | NA      | 172.31.1.1       | NA
2 | 24940   | 65.108.114.130   | HETZNER-AS, DE
3 | 24940   | 88.198.29.137    | HETZNER-AS, DE
4 | 24940   | 213.239.228.13   | HETZNER-AS, DE
5 | 24940   | 213.239.224.25   | HETZNER-AS, DE
6 | 24940   | 213.133.121.234  | HETZNER-AS, DE
7 | 13335   | 162.158.236.13   | CLOUDFLARENET, US
8 | 13335   | 1.1.1.1          | CLOUDFLARENET, US

root@s1:~# curl https://raw.githubusercontent.com/M1ndas/ttaspath/refs/heads/main/ttaspath.sh -s | bash -s 8.8.8.8
1 | NA      | 172.31.1.1       | NA
2 | 24940   | 65.108.114.130   | HETZNER-AS, DE
3 | 24940   | 88.198.29.141    | HETZNER-AS, DE
4 | 24940   | 213.239.228.1    | HETZNER-AS, DE
5 | 24940   | 213.239.224.37   | HETZNER-AS, DE
6 | 24940   | 213.133.118.130  | HETZNER-AS, DE
7 | 15169   | 142.251.53.71    | GOOGLE, US
8 | 15169   | 142.250.227.85   | GOOGLE, US
9 | 15169   | 8.8.8.8          | GOOGLE, US
```
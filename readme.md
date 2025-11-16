# ttaspath

- Runs `tcp traceroute` ('tt' part in the name) and `prints AS` ('as' part in the name) along the `network path` ('path' part in the name).

- Usefull in this situation: 
    - you have to deploy networked software on a customer machine on a customer network, 
    - you have access to the machine over ssh (or something else, like a PAM based web terminal), but you can't reach port 443 or 4505/4506 (or whatever) on your network, 
    - you ask - what is blocking the traffic our customer side or our side? 
    - answer - if only the first AS shows up in the output, that means tcp traffic can't leave customer network, if your AS shows up but the final destination is still not reachable - your side is blocking. 

- NOTE: the original uscase is fullfiled by just running traceroute -T with additional -A flag. It does not give you the AS name, only AS number, but that is offen sufficient to see that the customer network does not let the packets/segments leave the network.

### Comparative analysis w/ altenatives

- `mtr --aslookup --tcp --port=443 --report -n temu.ch`    --> only AS number, not name, but provides reverse DNS (PTR) lookup, default ipv6 use, packet stats, displays changing ips in path
- `traceroute -ATn -p 443 temu.ch`                         --> only AS number, not name, but provides packet stats, displays changing ips in path
- `./ttaspath temu.ch 443`                                 --> AS number and AS name, but no packet stats

### Run

```
curl https://raw.githubusercontent.com/M1ndas/ttaspath/refs/heads/main/ttaspath.sh -s | bash -s cnn.com 443
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

`bnr` or `bnr.sh`

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

### Future plans:

- Would probably be usefull to show the full traceroute and then the aspath or include the name of the AS in the traceroute -TA output
- Maybe include PTR lookups (this discloses that hetzner for example has direct peering with megafon ru: hetzner-gw.megafon.ru. https://en.wikipedia.org/wiki/MegaFon)

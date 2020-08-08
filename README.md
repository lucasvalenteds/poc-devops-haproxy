# POC: HAProxy

It demonstrates how to use [HAProxy](https://github.com/haproxy/haproxy) to route requests to multiple [Node.js](https://github.com/nodejs) servers running on [Docker](https://github.com/docker) containers.

We want HAProxy to redirect HTTP requests to `http://localhost:4000` to any running container.

## How to run

| Description | Command |
| :------------- | :------------- |
| Provision | `make up` |
| Destroy | `make down` |
| Show logs | `make logs` |
| Run tests | `make test` |

> Running `SCALE=N make up` will run N containers (e.g.: `SCALE=10 make up` will run 10 containers)

## Preview

```
           Name                          Command               State                    Ports                 
--------------------------------------------------------------------------------------------------------------
poc-devops-haproxy_proxy_1    /sbin/tini -- dockercloud- ...   Up      1936/tcp, 443/tcp, 0.0.0.0:4000->80/tcp
poc-devops-haproxy_server_1   docker-entrypoint.sh node  ...   Up      0.0.0.0:32792->3000/tcp                
poc-devops-haproxy_server_2   docker-entrypoint.sh node  ...   Up      0.0.0.0:32791->3000/tcp                
poc-devops-haproxy_server_3   docker-entrypoint.sh node  ...   Up      0.0.0.0:32788->3000/tcp                
poc-devops-haproxy_server_4   docker-entrypoint.sh node  ...   Up      0.0.0.0:32789->3000/tcp                
poc-devops-haproxy_server_5   docker-entrypoint.sh node  ...   Up      0.0.0.0:32790->3000/tcp                

```

```
audited 2 packages in 1.086s
found 0 vulnerabilities

Creating network "poc-devops-haproxy_server-network" with driver "bridge"
Building server
Step 1/6 : FROM node:alpine
 ---> 0854fcfc1637
Step 2/6 : WORKDIR /application
 ---> Using cache
 ---> 6303181eba3a
Step 3/6 : ENV PORT 3000
 ---> Using cache
 ---> a77ba85570a7
Step 4/6 : COPY dist/index.js .
 ---> Using cache
 ---> d9cadaf7b3cc
Step 5/6 : EXPOSE 3000
 ---> Using cache
 ---> 8bcb90848738
Step 6/6 : CMD [ "node", "index.js" ]
 ---> Using cache
 ---> 7efc8dab5528

Successfully built 7efc8dab5528
Successfully tagged server:latest
Creating poc-devops-haproxy_server_1 ... done
Creating poc-devops-haproxy_server_2 ... done
Creating poc-devops-haproxy_server_3 ... done
Creating poc-devops-haproxy_server_4 ... done
Creating poc-devops-haproxy_server_5 ... done
Creating poc-devops-haproxy_proxy_1  ... done
```

```
server_4  | Server running on port 3000
server_2  | Server running on port 3000
server_5  | Server running on port 3000
server_3  | Server running on port 3000
server_1  | Server running on port 3000
```

## Tests

```
processor      Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz
memory         16GiB System memory
```

### 2 containers

```
Running 30s test @ http://localhost:4000
30 connections

┌─────────┬──────┬──────┬───────┬──────┬─────────┬─────────┬──────────┐
│ Stat    │ 2.5% │ 50%  │ 97.5% │ 99%  │ Avg     │ Stdev   │ Max      │
├─────────┼──────┼──────┼───────┼──────┼─────────┼─────────┼──────────┤
│ Latency │ 0 ms │ 2 ms │ 5 ms  │ 7 ms │ 2.44 ms │ 1.29 ms │ 47.56 ms │
└─────────┴──────┴──────┴───────┴──────┴─────────┴─────────┴──────────┘
┌───────────┬────────┬────────┬─────────┬─────────┬──────────┬────────┬────────┐
│ Stat      │ 1%     │ 2.5%   │ 50%     │ 97.5%   │ Avg      │ Stdev  │ Min    │
├───────────┼────────┼────────┼─────────┼─────────┼──────────┼────────┼────────┤
│ Req/Sec   │ 5443   │ 5443   │ 10367   │ 10559   │ 10162.07 │ 922.5  │ 5441   │
├───────────┼────────┼────────┼─────────┼─────────┼──────────┼────────┼────────┤
│ Bytes/Sec │ 653 kB │ 653 kB │ 1.24 MB │ 1.27 MB │ 1.22 MB  │ 111 kB │ 653 kB │
└───────────┴────────┴────────┴─────────┴─────────┴──────────┴────────┴────────┘

Req/Bytes counts sampled once per second.

305k requests in 30.05s, 36.6 MB read
```

### 5 containers

```
Running 30s test @ http://localhost:4000
30 connections

┌─────────┬──────┬──────┬───────┬───────┬─────────┬─────────┬──────────┐
│ Stat    │ 2.5% │ 50%  │ 97.5% │ 99%   │ Avg     │ Stdev   │ Max      │
├─────────┼──────┼──────┼───────┼───────┼─────────┼─────────┼──────────┤
│ Latency │ 2 ms │ 3 ms │ 8 ms  │ 11 ms │ 3.56 ms │ 1.85 ms │ 63.84 ms │
└─────────┴──────┴──────┴───────┴───────┴─────────┴─────────┴──────────┘
┌───────────┬────────┬────────┬────────┬────────┬─────────┬─────────┬────────┐
│ Stat      │ 1%     │ 2.5%   │ 50%    │ 97.5%  │ Avg     │ Stdev   │ Min    │
├───────────┼────────┼────────┼────────┼────────┼─────────┼─────────┼────────┤
│ Req/Sec   │ 4115   │ 4115   │ 7667   │ 7847   │ 7327.34 │ 832.55  │ 4115   │
├───────────┼────────┼────────┼────────┼────────┼─────────┼─────────┼────────┤
│ Bytes/Sec │ 494 kB │ 494 kB │ 920 kB │ 942 kB │ 879 kB  │ 99.9 kB │ 494 kB │
└───────────┴────────┴────────┴────────┴────────┴─────────┴─────────┴────────┘

Req/Bytes counts sampled once per second.

220k requests in 30.05s, 26.4 MB read
```

### 10 containers

```
Running 30s test @ http://localhost:4000
30 connections

┌─────────┬──────┬──────┬───────┬───────┬─────────┬─────────┬──────────┐
│ Stat    │ 2.5% │ 50%  │ 97.5% │ 99%   │ Avg     │ Stdev   │ Max      │
├─────────┼──────┼──────┼───────┼───────┼─────────┼─────────┼──────────┤
│ Latency │ 1 ms │ 4 ms │ 11 ms │ 16 ms │ 4.35 ms │ 2.65 ms │ 67.65 ms │
└─────────┴──────┴──────┴───────┴───────┴─────────┴─────────┴──────────┘
┌───────────┬────────┬────────┬────────┬────────┬────────┬─────────┬────────┐
│ Stat      │ 1%     │ 2.5%   │ 50%    │ 97.5%  │ Avg    │ Stdev   │ Min    │
├───────────┼────────┼────────┼────────┼────────┼────────┼─────────┼────────┤
│ Req/Sec   │ 3523   │ 3523   │ 6607   │ 6803   │ 6236.3 │ 799.16  │ 3522   │
├───────────┼────────┼────────┼────────┼────────┼────────┼─────────┼────────┤
│ Bytes/Sec │ 423 kB │ 423 kB │ 793 kB │ 816 kB │ 748 kB │ 95.9 kB │ 423 kB │
└───────────┴────────┴────────┴────────┴────────┴────────┴─────────┴────────┘

Req/Bytes counts sampled once per second.

187k requests in 30.05s, 22.4 MB read
```

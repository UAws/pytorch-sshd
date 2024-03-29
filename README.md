Ref : https://gist.github.com/tae-jun/871e62542670c6fdd48a7f098dbbb80c

```docker
wget http://vmv.re/HPZlQ -O docker-compose.yml && vim docker-compose.yml
sudo docker-compose up -d
```

Check already allocated ports to avoid conflict

```
netstat -anpt
```

Using following code to start docker ...

```docker
version: "3.9"
services:
  research:
    image: ghcr.io/uaws/pytorch-sshd:pytorch-1.11.0-ubuntu-20.04
      #environment:
      #- NVIDIA_VISIBLE_DEVICES=3  # or device number (e.g. 0) to allow a single gpu
    ports:
      - "60000:8888"  # port for JupyterLab (or JupyterNotebook)
      - "60001:22"  # port for ssh
    volumes:
      - /data/biao_docker_data/:/data
    deploy:
      resources:
        reservations:
          devices:
          - driver: nvidia
            device_ids: ['3']
            capabilities: [gpu]
```

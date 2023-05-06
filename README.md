Ascii Tea Party
===============
AsciiDoctor is AWFUL to "just use"... this aims to fix that.

(aka: I'm jaming everything into a Docker container in Gitea, and hoping the pipeline pushes out useful things on the backend)

R&D into Gitea Actions (w/ Runners)
-----------------------------------
Source: https://blog.gitea.io/2023/03/hacking-on-gitea-actions/


Setup/Configuration Steps
-------------------------
1. Get a Gitea instance running
2. Set the configuration to allow Actions
```ini
[actions]
ENABLED=true
```
3. Download the runner binary WITH access to Docker (due to architecture)
4. (Optional) Ideally, an image is prepared with ALL needed binaries within it.
5. Prepare Gitea for the action/runner (http://127.0.0.1:3000/admin/runners) 
6. Register the runner with the Gitea ()
   1. Example: `./act_runner_0-1-7 register --no-interactive --instance http://127.0.0.1:3000 --token hLPi41NhM1DYTe9hCaqsZCBVFzw1WuQ0zox5BtVw`
   2. The current runner setup HATES loopback addresses, so use the IP address of the host
7. Run the runner (`./act_runner daemon`)
```bash 
INFO Registering runner, arch=amd64, os=linux, version=v0.1.7. 
WARN Runner in user-mode.                         
INFO Runner name is empty, use hostname 'ab6268cac193'. 
DEBU Successfully pinged the Gitea instance server 
INFO Runner registered successfully.              
ab6268cac193:/data$ 
```

Example of Using a Docker Container/Docker-Compose
--------------------------------------------------
```bash
docker run -e GITEA_INSTANCE_URL=http://192.168.8.18:3000 -e GITEA_RUNNER_REGISTRATION_TOKEN=<runner_token> -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/data:/data --name my_runner gitea/act_runner:nightly
```
```yaml
...
  gitea:
    image: gitea/gitea
    ...

  runner:
    image: gitea/act_runner
    restart: always
    depends_on:
      - gitea
    volumes:
      - ./data/act_runner:/data
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - GITEA_INSTANCE_URL=<instance url>
      - GITEA_RUNNER_REGISTRATION_TOKEN=<registration token>
```
Source: https://gitea.com/gitea/act_runner


# HOW TO

1. Install git and Docker

```
sudo apt install git docker.io -y
```
2. Clone this repo

```
git clone https://github.com/p31d4/ropemporium_playground.git
```
3. Build the Docker image

```
cd ropemporium_playground
sudo bash build_docker.sh
```
4. Download a challenge. Example:

```
bash get_challenge.sh --challenge ret2csu --arch x86_64
```
5. Start the Docker image

```
sudo bash run_docker.sh `pwd`
```
6. Activate the virtual env and enjoy. Example:

```
. /opt/venv/bin/activate
cd ~/git_repos/ret2csu/x86_64
python3 ret2csu_exploit.py
python3 ret2csu_exploit.py GDB
```

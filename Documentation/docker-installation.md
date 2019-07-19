## Docker Configuration
Normally (and in this guide) Docker engine is used as the container runtime for the Kubernetes clusters. You have the freedom to choose between many other container runtimes, such as, but not limited to, containerd, cri-o, and Kubernetes CRI. Since Docker is easy to install and configure on most platforms, and also is the only platform that supports Windows containers currently, so mostly this is the preferred container runtime to be used. 

I am using Ubuntu, thus the steps mentioned here are for Linux based distributions. 

Note that on Windows platform, installation of Docker engine is a process that contains graphical application and also does not require manual intervention for the installation. There are a couple of requirements: 

1. Windows 10 Pro is needed; Home versions are not supported, see second point.
2. Hypervisor is needed, to be precise Hyper-V is needed, not other virtualization tools such as VirtualBox. 

On Ubuntu, same applies and your CPU needs to support virtualization but that is normally not a problem on latest Linux kernels. On Ubuntu, you can install Ubuntu from the APT, 

``` shell
$ sudo apt-get install docker.io 
```
This will install the Docker engine and setup most of the necessary services. You might have to start the system yourself, to do so execute the following commands to enable/start the service, 

``` shell
$ sudo systemctl start docker 
$ sudo systemctl enable docker
```
Once you are done with all these steps... Go ahead and check out if `docker` command-line is available to you. 

``` shell
$ docker --version
```
If this command provides a useful result then you are all set, if it says something else, like docker command not found, you can try rebooting your system or check if the installation was successful. 

### Post-installation scripts on Linux
Docker demons has the same priviledges as `root` on your machine. Thus, you can only execute a handful commands via `docker` executable. In order to get some information out of your Docker platform, such as the images or containers&mdash;which requires the connection to underlying UNIX socket&mdash;you require to execute the command as `sudo`. These steps are available on Docker website for [Linux installation](https://docs.docker.com/install/linux/linux-postinstall/) too, but I am writing them here as well. 

In most cases, you might not need to do that, for example if your user account already has access to the same group where Docker is deployed&mdash;`docker`. To test if the next steps are necessary and required on your platform, run, 

``` shell
$ docker images
```
If the problem is something like UNIX socket cannot be accessed, then you need to follow along with these steps to completely configure the Docker engine. **Note that** if you skip out these steps, your Kubernetes images might not be pulled properly and your cluster might face some undefined behavior. 

First of all, you need to make sure that you are having a docker group, in most cases, it will be created for you during the installation of Docker engine, but if it is not created, create one, 

``` shell
$ sudo groupadd docker
```
Now, go ahead and add yourself (or the user who will be accessing the Docker engine) to the group, 

``` shell
$ sudo usermod -aG docker $USER
```
Now a quick reboot would be enough to get you started; you can also log out and re login, but reboot would be better. 

``` shell
$ sudo reboot
```
Upon relogin, execute the following command to verify everything is going smooth. 

``` shell
$ docker images
```
By this time you will have Docker ready and next steps you can take according to Docker development or follow along with Kubernetes cluster deployment guide. 
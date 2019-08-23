## Kubernetes Cluster Deployment 
For a quick testing purpose, one can quickly deploy a Kubernetes cluster on their own machines, on their virtual machines, or secondary systems that are supported by the mainstream Kubernetes environments. In this repository, you will find a couple of helpful guides to deploy and maintain a Kubernetes cluster (single node or multi node cluster). There are two ways in which you can create clusters for Kubernetes, online and offline. 

Online clusters in this document mean the clusters that some party is offering as a hosted solution for you, and you have least access to the cluster or resources, in most cases you can only execute a handful of commands or create a handful of services or resources. 

Offline clusters mean the clusters that you deploy yourself, they include cloud-based clusters too. These clusters provide the maximum control over the clusters and let you create maximum kind of services and resources. 

### Online clusters
The following services enable you to quickly utilize a Kubernetes cluster deployed online. 

1. [Play with Kubernetes](https://labs.play-with-k8s.com/)
2. [Kubernetes for Beginners](https://training.play-with-kubernetes.com/kubernetes-workshop/)

Note that they are temporary clusters, and only for learning or exploration purposes. Your data, or container/pod states will not be maintained and they will be nuked after a specified time. 

### Offline clusters
In case if you want to create an offline cluster, there are following ways in which you can get started with the creation of a cluster and test the service right away. 

1. [Minikube](https://github.com/kubernetes/minikube)
2. [Docker for Windows/Mac](https://www.docker.com/products/docker-desktop)
3. [Kubernetes single-node cluster](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)

There are some cloud providers that support Kubernetes out of the box as well, you can quickly deploy a Kubernetes cluster on their infrastructure and connect to it using the command-line tools and integrate your local `kubectl` with it. This provides the best possible experience for development or testing purposes, and you can check out the documentations for these services on their platforms. 

1. [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/)
2. [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/)
3. [Alibaba Cloud Container Service for Kubernetes(ACK)](https://www.alibabacloud.com/product/kubernetes)
4. [Kubernetes on AWS](https://aws.amazon.com/kubernetes/)

In case if you want to follow along with the installation of the Kubernetes on your own machines, via any of the solutions provided above, follow along with the post ahead, or purchase a solution from one of the cloud vendors. 

## Installation 
I will use Ubuntu for this guide, at the time of this authoring (June, 2019) Ubuntu has the LTS 18.04, thus my focus is to make sure that the guide works with at least the latest LTS release of the Ubuntu. I will _try_ to modify the documentation once the next LTS comes up 20.04&mdash;until then, follow along, compadre. 

### Setting up machine
At this stage, I assume that you have Ubuntu 18.04 or latest installed and configured. Most of the tutorials out there require that you update the hostname of your machines, well I believe that is not necessary unless you want to utilize the hostnames to communicate with the machines (instead of IP addresses). If you want to follow along with that; the reason why I won't follow along with this is that my most Kubernetes clusters are deployed on cloud and I do not need to manage the VMs, but if do need to do so, then execute the following command to perform this action, 
``` shell
$ sudo hostnamectl set-hostname "kubernetes-master" # or just k8s-master
```
This will update your hostname and set it to kubernetes-master; or k8s-master. Once this is done, your master node now has a name that can be used as an alias and you can configure your host endpoints with this label. 

> Of course you can call it anything, k8s-master or kubernetes-control-plane are just a few naming conventions followed on the Internet and everywhere, and since most people just copy and paste the commands&mdash;like you, ehm&mdash;this name has taken popularity. 

A good tutorial I found online also made a mention of the fact that you should also modify the host files, `/etc/hosts` and make it point to the IP address of your k8s-master node, and to get the IP address of the host you can try, 
```
$ hostname -I
```
This can return the list of the IP addresses, and if this does not work then you can check with your settings for the network adapter or card that you are using. Does this work? 
```
$ ip add
```
Once you have the IP address you can modify the hosts file and add a new record for the hostnames in the file as, 
``` text
1.2.3.4    k8s-master
```
Now that our machine is ready in the network, we can now go ahead and install the necessary packages for the Ubuntu OS as well as for containerization technology and then lastly the Kubernetes cluster management software. 
### Downloading packages
First of all, setup the HTTP(S) for APT, execute the following commands to download and install the `apt-transport-https` package.
``` shell
$ sudo apt-get install apt-transport-https curl -y
```
This will add the packages for the package download over HTTPS if that is not enabled, yet. Once done, next we need to setup the repositories for Docker as well as for Kubernetes. The Docker package that we will be using is `docker.io`, which is made available inside the default packages in Ubuntu 18.04. However in the case of Kubernetes we need to setup the package repositories, and the keys to access the repositories. Follow the following steps to perform those actions. 
``` shell
$ # Get the key from Google servers
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
```
Now once that you have the key, go ahead and add the repository to your APT list, 
``` shell
$ # Add the xenial repository as that work just fine. 
$ sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
```
### Setting up Container Runtime
We will be using Docker as a Container Runtime for our Kubernetes cluster. You can check out the other guide to explore how Docker has to be installed (it can be found in the same parent directory). 

#### Disable swapping 
Swapping enables your system to utilize some disk space as memory for the programs. This can improve the performance of your systems for a long run, but doesn't help much in cases where you need fast access (since disk seeking is required to capture the data), thus Kubernetes recommends that you disable the swap from your OS. You can do that using, 

``` shell
$ sudo swapoff -a
```
This might take a couple of seconds, to a couple of minutes depending upon how much your system has used the swapping feature on the machine. On fresh instances it might take just a couple of seconds (or even milliseconds). 

### Downloading `kubeadm`

Before you get started, and after everything is done, you need to download and setup the `kubeadm` command. If you have been following the steps in this tutorial, execute:

```
$ sudo apt-get install kubeadm
```

This will install the `kubeadm`, and you will be able to follow along with the next steps in this tutorial. 

### Booting up the cluster
Once everything is done and your processes are running, all you need to do is execute this command. 

``` shell
$ sudo kubeadm init --pod-network-cidr=172.168.10.0/24
```
You should check if you need to use this network subnet for your container images, since if you already have something deployed on this network it might cause collisions between your resources. But if everything is okay to go, just press enter and let Kubernetes setup the cluster master for you. 

A couple of things to note here:  

1. Kubeadm is available; of course. 
2. Make sure Docker is up and running, and that it can be accessed without `sudo`.
3. This network subnet does not contain your services. 
4. Your ethernet or other network cards do not require any configurations. 
5. Internet access is available since Kubernetes requires to download a bunch of images to bootstrap. 

Once everything is perfectly done, Kubernetes will show you the details of the steps that it has just performed. So far you have configured Kubernetes master node, and you need to add a bunch of worker nodes so that your cluster can function the way it is needed to&mdash;if you do not want to add more nodes or if you cannot add more nodes, then keep reading I will guide you on how you can use a single-node cluster. 

If you execute the command for `kubectl`, you will see some sort of errors showing that the connection cannot be made. The reason is that Kubernetes configurations need to be copied to your home directories for `kubectl` to function properly. 

### Adding nodes to cluster
The previous command you executed, will also show you the commands that you need to execute on other systems in order to bring them into the cluster. These commands will create a new directory `.kube` and then store the configurations there, 

``` shell
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Now after this if you execute the commands, such as `kubectl get nodes`, it will return the number of nodes that you have. 

``` shell
$ kubectl get nodes
NAME                STATUS     ROLES    AGE   VERSION
kubernetes-master   NotReady   master   3m    v1.13.2
```
You can see that the status currently says, **NotReady**. The reason for this is that you currently have not deployed a pod network, which is necessary and does not come with Kubernetes default installation. 

Tip: Try executing, `kubectl describe node kubernetes-master`, and see what it says. 
### Deploying pod network
For Pod Network, there are multiple options available for you. On this [Kubernetes documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network) for example, there are more than 5 options for you to setup this step.

For example, we go ahead and deploy the Flannel network, from this GitHub repository, https://github.com/coreos/flannel, there is a `kube-flannel.yml` file under the **Documentation** directory. 

``` shell
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
```
Once you deploy this, you can go back and execute the `kubectl get nodes` command after 15-20 seconds and you can see that your node is now **Ready**. Now you can go ahead and try out other samples to deploy the applications, from other directories inside the same repository. Your resources will be created and you can play with more content as needed. 

You can also find the documentation for Helm charts in the same directory and configure it to work around with Helm charts. 

For more information, check out this documentation, https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

### Adding worker nodes
If you have more nodes on the same network that can be used as worker nodes, then you should execute the following command from the output of `kubeadm`, and add them to this network so that your master node can schedule pods on them too. 

``` shell
$ kubeadm join <master-ip-address>:<port> --token <security-token> --discovery-token-ca-cert-hash sha256:<provided-hash>
```
This command can also be captured from the output of the `kubeadm` command, it is in the end of the output. 

**But, but, but**, if you do not have worker nodes then you will not be able to schedule pods on your master node because of the default settings and configurations of Kubernetes taints and tolerations and how they work. In order to bypass the default settings you can untaint the nodes to allow pods to be scheduled on master node too. 

``` shell
$ kubectl taint nodes --all node-role.kubernetes.io/master-
```
Once this is done, your pods will be scheduled even with one node (master node!) and you will not longer see an error while creating the pods. Then you can follow along other tutorials in the repository and explore how containers are made and how services are created. 

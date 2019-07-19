## Helm Installation
For those who are unaware, Helm is to Kubernetes, what APT is to Ubuntu; a **package manager**. Helms enables developers to _package_ and ship their resources for Kubernetes as packages, which Helm calls [_charts_](https://helm.sh/docs/developing_charts/). The deployment, updating and removal of the charts is managed by the Helm tool itself. Helm has two parts, one is the client-side binary, that is Helm itself and the other one is the binary that executes on the server (or your cluster), which is called Tiller. 

Helm makes software deployment to Kubernetes real easy, and that would go all in vain if the deployment of Helm itself was a tough job. That is why Helm itself is quite easy to manage and deployment on Kubernetes clusters. Download the Helm binaries from [Helm website](https://github.com/helm/helm/releases/tag/v2.14.1), or check out the [installation guides](https://helm.sh/docs/using_helm/#installing-helm) for package managers like Chocolatey, Homebrew etc. on other platforms. There will be two binaries that you are going to use, 

1. Helm
2. Tiller

As already mentioned, the Helm binary is the client-side binary and Tiller binary is the executable that runs in your cluster. Your Helm component manages the uploading of _charts_ to your Kubernetes cluster and Tiller manages how to deploy the resources and to maintain a connection between them. 

### Download installers
Installers and binaries for Helm are available on their GitHub repository, and you can find the one suitable for your use case. Check out the [releases](https://github.com/helm/helm/releases) and find the one suitable for your platform. What you will receive will be a folder, an archive that holds the executables. Here are the executables for my Windows platform, same is made available for Linux and other platforms and you only have to utilize the `helm.exe` executable. 

``` text
$ ls 
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         6/5/2019   9:19 PM       42084352 helm.exe
-a----         6/5/2019   9:19 PM          11343 LICENSE
-a----         6/5/2019   9:19 PM           3204 README.md
-a----         6/5/2019   9:19 PM       43162112 tiller.exe
```
### Install Helm and Tiller
The installation is as simple as just executing the `helm` binary, and that you can do using, 

``` shell
$ helm init --client-only
```
That `--client-only` flag guides the Helm installer that this installation does not require a Tiller component to be deployed and installed in the Kubernetes cluster. 

After this step, you will have your local installation done and... If you already have a Kubernetes cluster deployed, then you can also go ahead and setup the Tiller. The step to do that is the same as the previous one, 

``` shell
$ helm init --history-max 200
```
This will setup the local Helm client (if not already done) and will go ahead and deploy the Tiller in your cluster. Note that the `--history-max` flag limits the number of charts or resources that your Helm and Tiller have to manage, as they can grow quickly. This is why, it is recommended to notify the Helm initializer to limit the number of history to maintain for the charts and components. 

But before you go ahead and do this, you need to first create a new Kubernetes Service Account and grant the cluster role via cluster role bindings to the service account that will be used by our Tiller service; this step is explained well [here](https://helm.sh/docs/using_helm/#tiller-and-role-based-access-control). You can find the Kubernetes resource that needs to be created in this repository under `helm/rbac.config.yaml` file. However, I am also copying here for your ease, 

``` yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```
You should use the `kubectl` command-line tool to create these resources, _and_ once you are done with this step, you would create the Tiller installation via the following command, 

``` shell
$ helm init --history-max 200 --service-account tiller
```
Tip: If you have already executed the command without the `--service-account` flag, then you can reset the process using, `$ helm reset --force`.

And **that's it**. Your Helm is not installed and configured, in order to test if everything went good, you can execute the following command to check that, 

``` shell
$ helm list
```
Or you can go ahead and try to deploy a Helm chart and see if that works; you can find a number of Helm charts here on [GitHub](https://github.com/helm/charts).

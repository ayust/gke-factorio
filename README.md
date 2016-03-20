# gke-factorio
This is a set of configuration files for running a Factorio headless server on Google Container Engine (aka GKE).
If you don't already have a GKE cluster set up, you'll need to [create a GKE cluster]
  (https://cloud.google.com/container-engine/docs/clusters/operations#creating_a_container_cluster)
  before you'll be able to use them.

### Setup

*Make sure to change `your-project-name` to the name of your own Cloud project.*

  1. [Reserve a static IP](https://console.cloud.google.com/networking/addresses/add) and attach it
     to one of the nodes in your cluster. (Technically this is optional, but it's highly recommended to
     prevent your server's IP address from changing arbitrarily.)

  2. [Create a persistent disk](https://console.cloud.google.com/compute/disksAdd) named `factorio` on which the save games
     will be stored. (Minimum size is fine.)

  3. Download the headless server tarball from https://www.factorio.com/download-headless and place it
    into the same directory as the `Dockerfile`.

  4. Build the docker image:<br/>
    `docker build -t gcr.io/your-project-name/factorio-headless:latest`

  5. Push the docker image to the container registry:<br/>
    `gcloud docker push gcr.io/your-project-name/factorio-headless:latest`
    
  6. Spin up the service:<br/>
    `kubectl create -f gke-factorio.yaml`

Now you can watch the progress of the server spinning up via `kubectl describe pod factorio`.
To find the port that you should use to connect, use `kubectl describe svc factorio` and then
look for a line that looks like this:

```
NodePort:               <unnamed>       31234/UDP
```

Use the IP you previously reserved and this port to connect in the Factorio client.

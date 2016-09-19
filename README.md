# gke-factorio
This is a set of configuration files for running a Factorio headless server on Google Container Engine (aka GKE).
If you don't already have a GKE cluster set up, you'll need to [create a GKE cluster]
  (https://cloud.google.com/container-engine/docs/clusters/operations#creating_a_container_cluster)
  before you'll be able to use them.

### Setup

*Make sure to change `your-project-name` to the name of your own Cloud project.*

  1. [Reserve a static IP](https://console.cloud.google.com/networking/addresses/add) and attach it
     to one of the nodes in your cluster. *(Technically this is optional, but it's highly recommended.
     Using a static IP means that your server's address won't change without warning.)*

  2. [Create a blank persistent disk](https://console.cloud.google.com/compute/disksAdd) named `factorio` on which the save games
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

### Configuration

If you want to tweak the Factorio server settings, you can change the values of the environment
variables being set in `gke-factorio.yaml`. If you've made changes to the configuration, it won't
take effect until you re-create the replication controller.

First, force a save in-game so that the server will write out a checkpoint to its main save file
(rather than just the autosave files):

```
Open the console with ~ then type the following:

/c game.server_save()
```

Then use `kubectl` to re-create the replication controller:

```
kubectl delete rc factorio-controller
kubectl create -f gke-factorio.yaml
```

(Note that the `create` command will try to create both the service and the replication controller again,
but since the service still exists, it'll give an error. That's okay.)

You can use the same process to update the version of the server - just grab the new server file, re-build and re-push the docker image, and then re-create the replication controller to restart the server.

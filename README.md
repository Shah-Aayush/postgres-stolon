# Postgres through Stolon Operator

Walkthrough of deploying custom image of postgres with extensions through stolon operator in kubernetes/openshift environment

## The Stolon Operator Key Components

The Stolon operator is a Kubernetes operator that manages PostgreSQL clusters using the Stolon framework. Stolon is a cloud-native PostgreSQL manager that provides high availability, automated failover, and replication. Here's an overview of how the Stolon operator works:

### Key Components

1. **Stolon Keeper**:
   - Manages PostgreSQL instances.
   - Each keeper runs a PostgreSQL instance and is responsible for starting, stopping, and monitoring it.
   - Keeps the PostgreSQL data directory in sync with the cluster state.

2. **Stolon Sentinel**:
   - Monitors the state of the PostgreSQL cluster.
   - Decides which keeper should be the master and which should be replicas.
   - Handles failover by promoting a replica to master if the current master fails.

3. **Stolon Proxy**:
   - Provides a single endpoint for clients to connect to the PostgreSQL cluster.
   - Routes client connections to the current master.
   - Ensures that clients always connect to the correct master instance.

4. **Stolonctl**:
   - Command-line tool for managing the Stolon cluster.
   - Used to initialize the cluster, perform manual failovers, and manage cluster configuration.

## Deploy PostgreSQL through Stolon Operator

To deploy PostgreSQL using the Stolon operator on OpenShift, follow these detailed steps. Each configuration file and the commands required to set up the deployment are explained below.

### Explanation of Deployment Files

1. **[`role.yaml`](./role.yaml)**:
   - Defines the permissions required by Stolon components (pods, services, configmaps, etc.) in the namespace.

2. **[`role-binding.yaml`](./role-binding.yaml)**:
   - Binds the role defined in [`role.yaml`](./role.yaml) to the service account used by Stolon.

3. **[`secret.yaml`](./secret.yaml)**:
   - Stores sensitive information such as passwords for the Stolon components.

4. **[`stolon-keeper_new.yaml`](./stolon-keeper_new.yaml)**:
   - Defines the deployment for the Stolon Keeper, which manages the PostgreSQL instances.

5. **[`stolon-keeper-service.yaml`](./stolon-keeper-service.yaml)**:
   - Defines the service for the Stolon Keeper, exposing it within the cluster.

6. **[`stolon-proxy_new.yaml`](./stolon-proxy_new.yaml)**:
   - Defines the deployment for the Stolon Proxy, which routes client connections to the correct PostgreSQL instance.

7. **[`stolon-proxy-service.yaml`](./stolon-proxy-service.yaml)**:
   - Defines the service for the Stolon Proxy, exposing it within the cluster.

8. **[`stolon-sentinel_new.yaml`](./stolon-sentinel_new.yaml)**:
   - Defines the deployment for the Stolon Sentinel, which monitors the state of the PostgreSQL cluster.

9. **[`stolon-sentinel-service.yaml`](./stolon-sentinel-service.yaml)**:
   - Defines the service for the Stolon Sentinel, exposing it within the cluster.

10. **[`stolonctl-pod.yaml`](./stolonctl-pod.yaml)**:
    - Defines a pod for running `stolonctl` commands to initialize and manage the Stolon cluster.

### Steps to Deploy Stolon on OpenShift

1. **Create a New Project**:
   ```sh
   oc new-project <new-namespace>
   ```

2. **Create a Service Account**:
   ```sh
   oc create sa stolon-sa -n <new-namespace>
   ```

   - Assign the [`anyuid`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME%20copy.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A43%2C%22character%22%3A17%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A73%2C%22character%22%3A18%7D%7D%5D%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "Go to definition") Security Context Constraints (SCC) to the service account:
     ```sh
     oc adm policy add-scc-to-user anyuid -z stolon-sa -n <new-namespace>
     ```

3. **Assign Required Roles**:
   - Update [`role.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Frole.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22role.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/role.yaml") and [`role-binding.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Frole-binding.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22role-binding.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/role-binding.yaml") with the new namespace and service account name.
   - Apply the role and role binding:
     ```sh
     oc apply -f role.yaml -n <new-namespace>
     oc apply -f role-binding.yaml -n <new-namespace>
     ```

4. **Create Secrets**:
   - Ensure [`secret.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fsecret.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22secret.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/secret.yaml") is configured correctly for the new namespace.
   - Apply the secret:
     ```sh
     oc apply -f secret.yaml -n <new-namespace>
     ```

5. **Deploy Stolon Keeper**:
   - Update [`stolon-keeper_new.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-keeper_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolon-keeper_new.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolon-keeper_new.yaml") and [`stolon-keeper-service.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-keeper-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolon-keeper-service.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolon-keeper-service.yaml") with the new namespace.
   - Apply the configurations:
     ```sh
     oc apply -f stolon-keeper_new.yaml -n <new-namespace>
     oc apply -f stolon-keeper-service.yaml -n <new-namespace>
     ```

6. **Deploy Stolon Proxy**:
   - Update [`stolon-proxy_new.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-proxy_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolon-proxy_new.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolon-proxy_new.yaml") and [`stolon-proxy-service.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-proxy-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolon-proxy-service.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolon-proxy-service.yaml") with the new namespace.
   - Apply the configurations:
     ```sh
     oc apply -f stolon-proxy_new.yaml -n <new-namespace>
     oc apply -f stolon-proxy-service.yaml -n <new-namespace>
     ```

7. **Deploy Stolon Sentinel**:
   - Update [`stolon-sentinel_new.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-sentinel_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolon-sentinel_new.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolon-sentinel_new.yaml") and [`stolon-sentinel-service.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-sentinel-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolon-sentinel-service.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolon-sentinel-service.yaml") with the new namespace.
   - Apply the configurations:
     ```sh
     oc apply -f stolon-sentinel_new.yaml -n <new-namespace>
     oc apply -f stolon-sentinel-service.yaml -n <new-namespace>
     ```

8. **Initialize Stolon Cluster**:

   - Update [`stolonctl-pod.yaml`](command:_github.copilot.openSymbolInFile?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolonctl-pod.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22stolonctl-pod.yaml%22%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "/Users/aayush/Development/postgres-stolon/stolonctl-pod.yaml") with the new namespace.
   - Apply the configuration:
     ```sh
     oc apply -f stolonctl-pod.yaml -n <new-namespace>
     ```

9. **Verify Deployment**:
    - Check the status of the pods and services:
      ```sh
      oc get pods -n <new-namespace>
      oc get services -n <new-namespace>
      ```

10. **Use the PostgreSQL Instance**:
    - Go to the keeper pod and use the [`psql`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A132%2C%22character%22%3A32%7D%7D%5D%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "Go to definition") command:
      ```sh
      oc exec -it stolon-keeper-0 -- psql -h stolon-proxy -U stolon -d postgres -W
      ```
      > password: [`password1`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A136%2C%22character%22%3A20%7D%7D%5D%2C%2267acac5f-0db8-4cc7-8fdb-4749c13ae25f%22%5D "Go to definition")

By following these steps, you should be able to deploy Stolon on OpenShift successfully. 

## Using Custom PostgreSQL Image with Extensions

This guide will walk you through the process of creating a custom PostgreSQL image with your desired extensions, building the image, and deploying it using the Stolon operator.

### Step 1: Modify the Template Dockerfile

1. Navigate to the `dockerfiles` directory.
2. Open the `template.dockerfile` file.

```dockerfile
...upper layers...

#######
####### Build the final image
#######
FROM postgres:$PGVERSION
###### --- START ---
    
###### ADD YOUR CONFIG/EXTENSIONS installation steps here 
###### <your custom docker layers goes here>
######
###### --- END ---

...bottom layers...
```

3. Add your custom configuration and extensions in the section marked `###### --- START ---` and `###### --- END ---`.

### Step 2: Build the Custom Image

1. Open a terminal and navigate to the root directory of your project.
2. Run the following command to build the custom image:

```sh
docker build --build-arg PGVERSION=15 -t your-custom-image:tag -f dockerfiles/template.dockerfile .
```

Replace `your-custom-image:tag` with your desired image name and tag.

### Step 3: Update Deployment Files

1. Open the deployment files in your project (e.g., [`stolonctl-pod.yaml`](./stolonctl-pod.yaml), [`stolon-keeper_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-keeper_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%229c27392f-9dea-48f6-9188-6f3505eae950%22%5D "/Users/aayush/Development/postgres-stolon/stolon-keeper_new.yaml"), [`stolon-proxy_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-proxy_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%229c27392f-9dea-48f6-9188-6f3505eae950%22%5D "/Users/aayush/Development/postgres-stolon/stolon-proxy_new.yaml"), [`stolon-sentinel_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-sentinel_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%229c27392f-9dea-48f6-9188-6f3505eae950%22%5D "/Users/aayush/Development/postgres-stolon/stolon-sentinel_new.yaml")).
2. Update the [`image`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fdockerfiles%2Foriginal.dockerfile%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A2%2C%22character%22%3A13%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fdockerfiles%2Ftemplate.dockerfile%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A2%2C%22character%22%3A13%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME%20copy.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A109%2C%22character%22%3A81%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A145%2C%22character%22%3A25%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolon-proxy_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A43%2C%22character%22%3A8%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolonctl-pod.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A9%2C%22character%22%3A6%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolonctl-pod-config.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A9%2C%22character%22%3A6%7D%7D%5D%2C%229c27392f-9dea-48f6-9188-6f3505eae950%22%5D "Go to definition") field to use your custom image:

```yaml
spec:
  containers:
  - name: stolon-keeper
    image: your-custom-image:tag
    imagePullPolicy: Always
    ...
```

### Step 4: Deploy the Custom Image

1. Apply the updated deployment files to your Kubernetes/OpenShift cluster:

```sh
oc apply -f stolon-keeper_new.yaml -n <new-namespace>
oc apply -f stolon-proxy_new.yaml -n <new-namespace>
oc apply -f stolon-sentinel_new.yaml -n <new-namespace>
```

Replace `<new-namespace>` with your desired namespace.

### Step 5: Verify the Deployment

1. Check the status of the pods and services:

```sh
oc get pods -n <new-namespace>
oc get services -n <new-namespace>
```

2. Ensure that the pods are running and the services are available.

### Step 6: Use the PostgreSQL Instance

1. Connect to the PostgreSQL instance using the [`psql`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A137%2C%22character%22%3A41%7D%7D%5D%2C%229c27392f-9dea-48f6-9188-6f3505eae950%22%5D "Go to definition") command:.

By following these steps, you should be able to create, build, and deploy a custom PostgreSQL image with your desired extensions using the Stolon operator.


## Updating PostgreSQL Parameters

This guide will walk you through the process of updating PostgreSQL parameters using the Stolon operator. Some parameters, such as `shared_buffers`, require the keeper pod to be restarted to take effect.

### Step 1: Delete the Current Running `stolonctl` Pod

1. Check if there is any running `stolonctl` pod:

```sh
oc get pods -n <new-namespace> | grep stolonctl
```

2. If a [`stolonctl`] pod is running, delete it:

```sh
oc delete pod stolonctl -n <new-namespace>
```

### Step 2: Apply the Configuration in [`stolonctl-pod-config.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolonctl-pod-config.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22244a82aa-73e9-4def-8cbc-7fbe34e2d830%22%5D "/Users/aayush/Development/postgres-stolon/stolonctl-pod-config.yaml")

1. Open the [`stolonctl-pod-config.yaml`](./stolonctl-pod-config.yaml) file and ensure it contains the desired PostgreSQL parameters:

```yaml
    ...
    args: [
      "--cluster-name=kube-stolon",
      "--store-backend=kubernetes",
      "--kube-resource-kind=configmap",
      "--kube-namespace=postgres-stolon",
      "update",
      "--patch",
      '{
        "pgParameters": {
          "temp_buffers": "2GB",
          "shared_buffers": "12GB",
          "wal_buffers": "200000",
          "work_mem": "2GB",
          "max_connections": "300",
          "max_parallel_workers_per_gather": "6",
          "effective_cache_size": "2GB"
        }
      }'
    ]
    ...
```

2. Apply the configuration:

```sh
oc apply -f stolonctl-pod-config.yaml -n <new-namespace>
```

### Step 3: Restart the Keeper Pod (if necessary)

Some PostgreSQL parameters, such as [`shared_buffers`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fpostgres-stolon%2Fstolonctl-pod-config.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A23%2C%22character%22%3A11%7D%7D%5D%2C%22244a82aa-73e9-4def-8cbc-7fbe34e2d830%22%5D "Go to definition"), require the keeper pod to be restarted to take effect.

1. Get the name of the keeper pod:

```sh
oc get pods -n <new-namespace> | grep stolon-keeper
```

2. Delete the keeper pod to restart it:

```sh
oc delete pod <keeper-pod-name> -n <new-namespace>
```

Replace `<keeper-pod-name>` with the actual name of the keeper pod.

### Step 4: Verify the Changes

1. Check the status of the pods and services:

```sh
oc get pods -n <new-namespace>
oc get services -n <new-namespace>
```

2. Ensure that the pods are running and the services are available.

3. Connect to the PostgreSQL instance and verify the updated parameters:

```sh
oc exec -it stolon-keeper-0 -- psql -h stolon-proxy -U stolon -d postgres -W
```
> Password: `password1`

4. Run the following SQL command to check the updated parameters:

```sql
SHOW shared_buffers;
SHOW temp_buffers;
SHOW wal_buffers;
SHOW work_mem;
SHOW max_connections;
SHOW max_parallel_workers_per_gather;
SHOW effective_cache_size;
```

By following these steps, you should be able to update PostgreSQL parameters using the Stolon operator and ensure that the changes take effect.


## Image building

- go to stolon repo
- update the dockerfile there at `examples/kubernetes/image/docker`
   - copy contents there from dockerfiles/`custom-v1.2.dockerfile` if not sure
- build image : do it from stolon repo root path.
   - `docker build --build-arg PGVERSION=15 -t postgres-stolon:v1.7 -f examples/kubernetes/image/docker/Dockerfile .`
- stolon postgres image :
   `docker-na-public.artifactory.swg-devops.com/sec-guardium-next-gen-docker-local/postgres-stolon:v1.7`
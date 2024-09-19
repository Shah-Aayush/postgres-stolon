let's go through the files in the [`DEPLOYMENT`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%2200977b57-2087-4173-ad15-b7a6e3d67c24%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT") directory and explain their purpose. I'll also provide the steps and commands to deploy Stolon on OpenShift.

### Explanation of Files in [`DEPLOYMENT`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%2200977b57-2087-4173-ad15-b7a6e3d67c24%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT") Directory

1. **[`role.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Frole.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/role.yaml")**:
   - Defines the permissions required by Stolon components (pods, services, configmaps, etc.) in the namespace.

2. **`role-binding.yaml`**:
   - Binds the role defined in [`role.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Frole.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%2200977b57-2087-4173-ad15-b7a6e3d67c24%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/role.yaml") to the service account used by Stolon.

3. **`secret.yaml`**:
   - Stores sensitive information such as passwords for the Stolon components.

4. **[`stolon-keeper_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-keeper_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-keeper_new.yaml")**:
   - Defines the deployment for the Stolon Keeper, which manages the PostgreSQL instances.

5. **[`stolon-keeper-service.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-keeper-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-keeper-service.yaml")**:
   - Defines the service for the Stolon Keeper, exposing it within the cluster.

6. **[`stolon-proxy_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-proxy_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-proxy_new.yaml")**:
   - Defines the deployment for the Stolon Proxy, which routes client connections to the correct PostgreSQL instance.

7. **[`stolon-proxy-service.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-proxy-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-proxy-service.yaml")**:
   - Defines the service for the Stolon Proxy, exposing it within the cluster.

8. **[`stolon-sentinel-service.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-sentinel-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-sentinel-service.yaml")**:
   - Defines the service for the Stolon Sentinel, exposing it within the cluster.

9. **[`stolonctl-pod.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolonctl-pod.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolonctl-pod.yaml")**:
   - Defines a pod for running [`stolonctl`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolonctl-pod.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A3%2C%22character%22%3A8%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2Fdoc%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A10%2C%22character%22%3A18%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2Fdoc%2Fcommands_invocation.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A7%2C%22character%22%3A3%7D%7D%5D%2C%2200977b57-2087-4173-ad15-b7a6e3d67c24%22%5D "Go to definition") commands to initialize and manage the Stolon cluster.

### Steps to Deploy Stolon on OpenShift

1. **Create a New Project**:
   ```sh
   oc new-project <new-namespace>
   ```

2. **Create a Service Account**:
   ```sh
   oc create sa stolon-sa -n <new-namespace>
   ```

   - Assign the `anyuid` Security Context Constraints (SCC) to the service account:
     ```sh
     oc adm policy add-scc-to-user anyuid -z stolon-sa -n <new-namespace>
     ```    

3. **Assign Required Roles**:
   - Update [`role.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Frole.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/role.yaml") and `role-binding.yaml` with the new namespace and service account name.
   - Apply the role and role binding:
     ```sh
     oc apply -f DEPLOYMENT/role.yaml -n <new-namespace>
     oc apply -f DEPLOYMENT/role-binding.yaml -n <new-namespace>
     ```

4. **Assign [`anyuid`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2Fexamples%2Fopenshift%2FREADME.md%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A11%2C%22character%22%3A26%7D%7D%5D%2C%2200977b57-2087-4173-ad15-b7a6e3d67c24%22%5D "Go to definition") SCC to the Service Account**:
   ```sh
   oc adm policy add-scc-to-user anyuid -z stolon-sa -n <new-namespace>
   ```

5. **Create Secrets**:
   - Ensure `secret.yaml` is configured correctly for the new namespace.
   - Apply the secret:
     ```sh
     oc apply -f DEPLOYMENT/secret.yaml -n <new-namespace>
     ```

6. **Deploy Stolon Keeper**:
   - Update [`stolon-keeper_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-keeper_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-keeper_new.yaml") and [`stolon-keeper-service.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-keeper-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-keeper-service.yaml") with the new namespace.
   - Apply the configurations:
     ```sh
     oc apply -f DEPLOYMENT/stolon-keeper_new.yaml -n <new-namespace>
     oc apply -f DEPLOYMENT/stolon-keeper-service.yaml -n <new-namespace>
     ```

7. **Deploy Stolon Proxy**:
   - Update [`stolon-proxy_new.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-proxy_new.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-proxy_new.yaml") and [`stolon-proxy-service.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-proxy-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-proxy-service.yaml") with the new namespace.
   - Apply the configurations:
     ```sh
     oc apply -f DEPLOYMENT/stolon-proxy_new.yaml -n <new-namespace>
     oc apply -f DEPLOYMENT/stolon-proxy-service.yaml -n <new-namespace>
     ```

8. **Deploy Stolon Sentinel**:
   - Update [`stolon-sentinel.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2Fexamples%2Fkubernetes%2Fstolon-sentinel.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%2200977b57-2087-4173-ad15-b7a6e3d67c24%22%5D "/Users/aayush/Development/stolon/examples/kubernetes/stolon-sentinel.yaml") and [`stolon-sentinel-service.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolon-sentinel-service.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolon-sentinel-service.yaml") with the new namespace.
   - Apply the configurations:
     ```sh
     oc apply -f DEPLOYMENT/stolon-sentinel.yaml -n <new-namespace>
     oc apply -f DEPLOYMENT/stolon-sentinel-service.yaml -n <new-namespace>
     ```

9. **Initialize Stolon Cluster**:
   - Update [`stolonctl-pod.yaml`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Faayush%2FDevelopment%2Fstolon%2FDEPLOYMENT%2Fstolonctl-pod.yaml%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22d8fe06e8-f00d-4f2c-a270-3c7076779566%22%5D "/Users/aayush/Development/stolon/DEPLOYMENT/stolonctl-pod.yaml") with the new namespace.
   - Apply the configuration:
     ```sh
     oc apply -f DEPLOYMENT/stolonctl-pod.yaml -n <new-namespace>
     ```

10. **Verify Deployment**:
    - Check the status of the pods and services:
      ```sh
      oc get pods -n <new-namespace>
      oc get services -n <new-namespace>
      ```

By following these steps, you should be able to deploy Stolon on OpenShift successfully. If you encounter any issues, please let me know!

```
docker build --build-arg PGVERSION=${PGVERSION} -t ${TAG} -f examples/kubernetes/image/docker/Dockerfile .
```
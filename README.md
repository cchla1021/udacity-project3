**Note:** For the screenshots, you can store all of your answer images in the `answer-img` directory.

## Installing Grafana and Prometheus
```
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo add stable https://kubernetes-charts.storage.googleapis.com # this is deprecated
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --kubeconfig /etc/rancher/k3s/k3s.yaml
```

## Commands for Exposing Grafana - Resolve Unable to access project on localhost:3000
```
kubectl patch svc "prometheus-grafana" --namespace "monitoring" -p '{"spec": {"type": "LoadBalancer"}}'
kubectl --namespace monitoring port-forward svc/prometheus-grafana --address 0.0.0.0 3000:80
```

## Commands for Exposing the application
```
kubectl patch svc "frontend-service" -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward svc/frontend-service --address 0.0.0.0 8080:8080
```

# Setup the Jaeger and Prometheus source 
```
export jaeger_version=v1.28.0
mkdir -p jaeger-tracing

cat >> jaeger-tracing/jaeger.yaml <<EOF
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
 name: my-traces
EOF

kubectl apply -f jaeger-tracing/jaeger.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/crds/jaegertracing.io_jaegers_crd.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/service_account.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/role.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/role_binding.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/operator.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/cluster_role.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/cluster_role_binding.yaml

# Use the command below to deploy Nginx ingress-controller in the K8s cluster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.3/deploy/static/provider/cloud/deploy.yaml
kubectl get svc -l app.kubernetes.io/instance=my-traces

# Run port-forward command to map local port 16686 to service/my-traces-query port 16686
kubectl port-forward svc/my-traces-query --address 0.0.0.0 16686:16686

kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus --address 0.0.0.0 9090:9090
```

## Configuring Jaeger Data Source on Grafana
```
export namespace=observability
export jaeger_version=v1.28.0
ingress_name=$(kubectl get -n ${namespace} ingress -o jsonpath='{.items[0].metadata.name}'); \
ingress_port=$(kubectl get -n ${namespace} ingress -o jsonpath='{.items[0].spec.defaultBackend.service.port.number}'); \
echo -e "\n\n${ingress_name}.${namespace}.svc.cluster.local:${ingress_port}"
```

![pods](https://github.com/cchla1021/Project_Starter_Files-Building_a_Metrics_Dashboard/blob/main/answer-img/jaeger-grafana.PNG)
Copy the echoed URL (including port number) above and open Grafana UI to add the data source, ensure that the link is successful by selecting save&test                 
![pods](https://github.com/cchla1021/Project_Starter_Files-Building_a_Metrics_Dashboard/blob/main/answer-img/jaeger-datasource.PNG)

## Verify the monitoring installation
![pods](https://github.com/cchla1021/Project_Starter_Files-Building_a_Metrics_Dashboard/blob/main/answer-img/verify-installation.PNG)

## Setup the Jaeger and Prometheus source
![pods](https://github.com/cchla1021/Project_Starter_Files-Building_a_Metrics_Dashboard/blob/main/answer-img/Setup-the-Jaeger-and-Prometheus-source.PNG)

Reference link: How To Configure Jaeger Data Source On Grafana And Debug Network Issues With Bind-utilities([https://blog.mphomphego.co.za/blog/2021/07/25/How-to-configure-Jaeger-Data-source-on-Grafana-and-debug-network-issues-with-Bind-utilities.html#how-to-configure-jaeger-data-source-on-grafana-and-debug-network-issues-with-bind-utilities])

## Create a Basic Dashboard
Create a dashboard in Grafana that shows Prometheus as a source. Take a screenshot and include it here.
![pods](https://github.com/cchla1021/Project_Starter_Files-Building_a_Metrics_Dashboard/blob/main/answer-img/Grafana-Prometheus-Basic-Dashboard.PNG)

## Describe SLO/SLI
A Service-Level Objectives is a measurable goal set by the SRE team to ensure a standard level of performance during a specified period of time. Once we have a clear definition and objective for the level of performance we want to deliver then Service-Level Indicators (SLIs) comes in to do actual measurement of performance we defined in the SLO. In this case, SLI would be the actual measurement of the uptime. Perhaps during that year, you actually achieved 99.5% uptime and request-response time or 97.3% uptime and request response time. These measurements are SLI. Notice that the above example is a ratio which is a measurement to a given amount of time (the measured uptime and request-response time per year).

## Creating SLI metrics.
It is important to know why we want to measure certain metrics for our customer. Describe in detail 5 metrics to measure these SLIs. 
A Service-Level Indicator (SLI) is a specific metric used to measure the performance of a service. These metrics are relevant and built around the four signals (latency, Error Rate, Traffic, and Saturation)

* Latency: Latency is important to monitor since this will tell the developers how long it takes to response to a request and usually measured in millisecond (ms).
* Error Rate: The errors often expressed as a fraction of all requests received. (eg. percentage of HTTP 500 responses).
* Traffic: Network is important to monitor since the developer can see how much bandwith is required for a service to function. With this data the developer can look for ways to decrese the amount of bandwith required.
* Uptime: Uptime is important to monitor so that developers know the percentage of the time the service is running. If it drops below a certain point this can be cause for concern and if it was not tracked it would be hard to tell how the service is handling.


## Create a Dashboard to measure our SLIs
Create a dashboard to measure the uptime of the frontend and backend services We will also want to measure to measure 40x and 50x errors. Create a dashboard that show these values over a 24 hour period and take a screenshot.

## Tracing our Flask App
*TODO:*  We will create a Jaeger span to measure the processes on the backend. Once you fill in the span, provide a screenshot of it here. Also provide a (screenshot) sample Python file containing a trace and span code used to perform Jaeger traces on the backend service.

## Jaeger in Dashboards
*TODO:* Now that the trace is running, let's add the metric to our current Grafana dashboard. Once this is completed, provide a screenshot of it here.

## Report Error
*TODO:* Using the template below, write a trouble ticket for the developers, to explain the errors that you are seeing (400, 500, latency) and to let them know the file that is causing the issue also include a screenshot of the tracer span to demonstrate how we can user a tracer to locate errors easily.

TROUBLE TICKET

Name:

Date:

Subject:

Affected Area:

Severity:

Description:


## Creating SLIs and SLOs
*TODO:* We want to create an SLO guaranteeing that our application has a 99.95% uptime per month. Name four SLIs that you would use to measure the success of this SLO.

## Building KPIs for our plan
*TODO*: Now that we have our SLIs and SLOs, create a list of 2-3 KPIs to accurately measure these metrics as well as a description of why those KPIs were chosen. We will make a dashboard for this, but first write them down here.

## Final Dashboard
*TODO*: Create a Dashboard containing graphs that capture all the metrics of your KPIs and adequately representing your SLIs and SLOs. Include a screenshot of the dashboard here, and write a text description of what graphs are represented in the dashboard.  

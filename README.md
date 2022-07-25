**Note:** For the screenshots, you can store all of your answer images in the `answer-img` directory.

## Setup/execute the Grafana, Jaeger, Prometheus, etc. 
```
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --kubeconfig /etc/rancher/k3s/k3s.yaml

export jaeger_version=v1.28.0
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/crds/jaegertracing.io_jaegers_crd.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/service_account.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/role.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/role_binding.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/operator.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/cluster_role.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/cluster_role_binding.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.3/deploy/static/provider/cloud/deploy.yaml

kubectl apply -f jaeger_crds/

# Run prometheus service
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus --address 0.0.0.0 9090:9090

# Run Jaeger operator
kubectl port-forward svc/my-traces-query --address 0.0.0.0 16686:16686
 
# Run frontend service
kubectl port-forward svc/frontend --address 0.0.0.0 8080:8083

#Run backend service
kubectl port-forward svc/backend --address 0.0.0.0 8080:8081
```

## Configuring Jaeger Data Source on Grafana
```
export namespace=default
export jaeger_version=v1.28.0
ingress_name=$(kubectl get ingress -o jsonpath='{.items[0].metadata.name}'); \
ingress_port=$(kubectl get ingress -o jsonpath='{.items[0].spec.defaultBackend.service.port.number}'); \
echo -e "\n\n${ingress_name}.${namespace}.svc.cluster.local:${ingress_port}"
```

## Commands for Exposing Grafana
```
kubectl --namespace monitoring port-forward $(kubectl get pods -n monitoring | grep "prometheus-grafana*" | awk '{print $1}') --address 0.0.0.0 3000:3000
```

## Commands for Exposing the application
```
kubectl patch svc "frontend-service" -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward svc/frontend-service --address 0.0.0.0 8080:8080
```

Open Grafana UI to add the data source, ensure that the link is successful by selecting save&test                 
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/jaeger-datasource.PNG)

## Verify the monitoring installation
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/verify-installation.PNG)

## Setup the Jaeger and Prometheus source
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/Grafana-HomePage.PNG)
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/Setup-the-Jaeger-and-Prometheus-source.PNG)

Reference link: How To Configure Jaeger Data Source On Grafana And Debug Network Issues With Bind-utilities([https://blog.mphomphego.co.za/blog/2021/07/25/How-to-configure-Jaeger-Data-source-on-Grafana-and-debug-network-issues-with-Bind-utilities.html#how-to-configure-jaeger-data-source-on-grafana-and-debug-network-issues-with-bind-utilities])

## Create a Basic Dashboard
Create a dashboard in Grafana that shows Prometheus as a source. Take a screenshot and include it here.
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/Grafana-Prometheus-Basic-Dashboard.PNG)

## Describe SLO/SLI
A Service-Level Objectives is a measurable goal set by the SRE team to ensure a standard level of performance during a specified period of time. Once we have a clear definition and objective for the level of performance we want to deliver then Service-Level Indicators (SLIs) comes in to do actual measurement of performance we defined in the SLO. In this case, SLI would be the actual measurement of the uptime. Perhaps during that year, you actually achieved 99.5% uptime and request-response time or 97.3% uptime and request response time. These measurements are SLI. Notice that the above example is a ratio which is a measurement to a given amount of time (the measured uptime and request-response time per year).

## Creating SLI metrics.
It is important to know why we want to measure certain metrics for our customer. Describe in detail 5 metrics to measure these SLIs. 
A Service-Level Indicator (SLI) is a specific metric used to measure the performance of a service. These metrics are relevant and built around the the following four golden signals (latency, Errors, Traffic, and Saturation)
* Latency — request time (in ms)
* Errors — how many failed HTTP responses are there? 4xx & 5xx errors.
* Traffic — how stressed is the system (based on no of HTTP requests/sec)
* Saturation — is too much memory or CPI being used compared to the the overall capacity of a service or its configuration?
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/Final-Dashboard.PNG)

## Create a Dashboard to measure our SLIs
Create a dashboard to measure the uptime of the frontend and backend services We will also want to measure to measure 40x and 50x errors. Create a dashboard that show these values over a 24 hour period and take a screenshot.

## Tracing our Flask App
Jaeger span to measure the processes on the backend. Screenshots sample Python file containing a trace and span code used to perform Jaeger traces on the backend service.
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/jaeger_flask_tracing.png)
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/jaeger_flask_tracing_span.PNG)

## Jaeger in Dashboards
Now that the trace is running, let's add the metric to our current Grafana dashboard. Once this is completed, provide a screenshot of it here.
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/Grafana-Jaeger.png)

## Report Error
Using the template below, write a trouble ticket for the developers, to explain the errors that you are seeing (400, 500, latency) and to let them know the file that is causing the issue also include a screenshot of the tracer span to demonstrate how we can user a tracer to locate errors easily.

TROUBLE TICKET

Name: The method is not allowed for the requested URL - Status Code 405

Date: 7/23/2022

Subject: MongoDB access failed

Affected Area: Backend star endpoint

Severity: Critical

Description: The "/star" endpoint throws 405 error which is caused by the mongodb://example-mongodb-svc.default.svc.cluster.local:27017/example-mongodb URL is not exist in the cluster. Need the MongoDB URL available for the cluster.


## Creating SLIs and SLOs
- Saturation: Percentage of CPU usage and Memory consumption.
- Uptime: The application/service should be up and running for at least 99.9% of the time on monthly basis.
- Latency: The average request response time should not exceed 15ms on monthly basis.
- Error Rate: The 20X status codes should be recorded for not less than 99.9% of the total requests whereas the 50X and 40X status codes should be recorded for less than 0.1% on all of the http requests made in month.

## Building KPIs for our plan
* Now that we have our SLIs and SLOs, create KPIs to accurately measure the following metrics:  
   - Latency KPI: Average Response time.  
   - Failure rate KPI: # of 5XX & 4XX Errors per 30 second / response rate per 30 seconds.    
   - Uptime services KPI for Backend and Frontend.  
   - Resource capcity KPI: CPU & RAM utilization.
   
## Final Dashboard
![pods](https://github.com/cchla1021/udacity-project3/blob/main/answer-img/FinalDashboard.PNG)
* Panels:
   - Flask HTTP request total: Status "200" - the amount of success HTTP requests per second
   - Uptime Backend Last 24 Hours
   - Uptime Frontend Last 24 Hours
   - Pods that are not ready - Pods status not running 
   - Pods Per Namespace
   - Status code 4XX/5XX the amount of failed requests per second
   - Average Response Time (Latency) - Average HTTP request/response time round trip.
   - Failed response per 30 second - Failed status code is not eqal "200"
   - CPU usage avaialble on the host

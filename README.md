**Note:** For the screenshots, you can store all of your answer images in the `answer-img` directory.

## Verify the monitoring installation

*TODO:* run `kubectl` command to show the running pods and services for all components. Take a screenshot of the output and include it here to verify the installation

Screensots:
[All Pods](answer-img/all_pods.png) |
[All Svc](answer-img/all_svc.png)|

## Setup the Jaeger and Prometheus source
*TODO:* Expose Grafana to the internet and then setup Prometheus as a data source. Provide a screenshot of the home page after logging into Grafana.

Screenshots:
[Grafana Homepage](answer-img/Grafana_HomePage.png)

## Create a Basic Dashboard
*TODO:* Create a dashboard in Grafana that shows Prometheus as a source. Take a screenshot and include it here.

Screenshots:
[Grafana dashboard + Prometheus as a source](answer-img/Basic_dashboard_with_prom_as_source.png)

## Describe SLO/SLI
*TODO:* Describe, in your own words, what the SLIs are, based on an SLO of *monthly uptime* and *request response time*.

A Service-Level Indicator (SLI) is a specific metric used to measure the performance of a service if it met its objective. In this context, it will require measuring the resouce usage such as disk, network and memory.

For SLO (service Level Object) it defines the objectives we want to achieve. In this context it will be something like 99% uptime and 90% of the response is under 250ms.

## Creating SLI metrics.
*TODO:* It is important to know why we want to measure certain metrics for our customer. Describe in detail 5 metrics to measure these SLIs. 

- error rate of our endpoints so that we know how often it is affecting the customer.
- Track when each http server error happen so that we could pin point when/how it happen.
- server/service uptime availablility to ensure customer can access our app anytime.
- Track amount of traffic that webserver able to handle before issues happens, so that we can rectify any resource issue.
- pod resource monitoring such as disk usage, cpu/mem usage to see if downtime is down to resource issue.

## Create a Dashboard to measure our SLIs
*TODO:* Create a dashboard to measure the uptime of the frontend and backend services We will also want to measure to measure 40x and 50x errors. Create a dashboard that show these values over a 24 hour period and take a screenshot.

Screenshots:
[Front and backend monitroing](answer-img/FrontEnd_BackEnd_Monitor.png)

## Tracing our Flask App
*TODO:*  We will create a Jaeger span to measure the processes on the backend. Once you fill in the span, provide a screenshot of it here.

Screenshots:
[Jaeger Tracing](answer-img/jaegaer_app.png)

## Jaeger in Dashboards
*TODO:* Now that the trace is running, let's add the metric to our current Grafana dashboard. Once this is completed, provide a screenshot of it here.

Screenshots:
[Tracing in Grafana](answer-img/jaeger_grafana.png)

## Report Error
*TODO:* Using the template below, write a trouble ticket for the developers, to explain the errors that you are seeing (400, 500, latency) and to let them know the file that is causing the issue.

> TROUBLE TICKET
>
>Name: 500 http error when posting to backend /star
>
>Date: 2021-10-20
>
>Subject: Mongodb is down
>
>Affected Area: Backend application /star endpoint
>
>Severity: ERROR
>
>Description: Appears that backend service cannot connect to MongoDB


## Creating SLIs and SLOs
*TODO:* We want to create an SLO guaranteeing that our application has a 99.95% uptime per month. Name three SLIs that you would use to measure the success of this SLO.

- uptime
- http requests rate
- http requests time
- cpu/mem usage

## Building KPIs for our plan
*TODO*: Now that we have our SLIs and SLOs, create KPIs to accurately measure these metrics. We will make a dashboard for this, but first write them down here.

### Uptime of services
- Backend svc uptime 
- Frontend svc uptime
- Trail svc uptime

### Success/Error rate
- No of 5XX, 4XX of all services
- Number of successful/failure requests per 30 sec

### Response time
- average success response time
- median response time
- 90th percentile reponse time

### Resource usage
- CPU usage
- Mem usage

## Final Dashboard
*TODO*: Create a Dashboard containing graphs that capture all the metrics of your KPIs and adequately representing your SLIs and SLOs. Include a screenshot of the dashboard here, and write a text description of what graphs are represented in the dashboard.  

Uptime of services: 
[Final Dashboard 1](answer-img/FinalDashboard_1.png) 

Error rate and Average Response Time: 
[Final Dashboard 2](answer-img/FinalDashboard_2.png) 

Median and 90th percentile response time and resouce usage like CPU and MEM: 
[Final Dashboard 3](answer-img/FinalDashboard_3.png)|
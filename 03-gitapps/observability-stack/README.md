Installs the following:

Grafana
Loki
Promtail
Prometheus Node Exporter
Prometheus


turn off pod security policy as its deprecated.

# Promtail

change loki address to:
http://loki-headless.operations:3100/loki/api/v1/push



# Data source
http://prometheus-kube-prometheus-prometheus.operations:9090/
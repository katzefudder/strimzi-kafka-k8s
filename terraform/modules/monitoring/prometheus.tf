resource "helm_release" "prometheus" {
  name             = "prometheus-community"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
  values = [
    "${file("${path.module}/config/monitoring.yaml")}"
  ]
}

// # https://bee42.com/de/blog/tutorials/grafana-helm-part-2/

resource kubernetes_config_map_v1 "grafana-dashboards" {
  metadata {
    name = "grafana-dashboards"
    labels = {
      "grafana_dashboard" = "1"
    }
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "loki.json" = "${file("${path.module}/config/dashboards/loki.json")}",
    "strimzi-kafka.json" = "${file("${path.module}/config/dashboards/strimzi-kafka.json")}",
    "strimzi-kafka-exporter.json" = "${file("${path.module}/config/dashboards/strimzi-kafka-exporter.json")}"
  }
}
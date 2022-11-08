resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
}
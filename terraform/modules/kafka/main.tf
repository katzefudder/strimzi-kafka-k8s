resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

resource "helm_release" "kafka-operator" {
  name             = "strimzi-kafka"
  repository       = "https://strimzi.io/charts/"
  chart            = "strimzi-kafka-operator"
  namespace        = kubernetes_namespace.kafka.metadata[0].name
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
  set {
    name = "replicas"
    value = "3"
  }
}

resource "kubernetes_manifest" "kafka-cluster" {
  manifest = {
    "apiVersion" = "kafka.strimzi.io/v1beta2"
    "kind" = "Kafka"
    "metadata" = {
      "name" = "my-kafka-cluster"
      "namespace" = "kafka"
    }
    "spec" = {
      "kafka" = {
          "replicas": 3,
          "listeners" = [
          {
            "name" = "plain"
            "port" = 9092
            "type" = "internal"
            "tls" = false
          }
        ],
        "storage": {
          "type": "persistent-claim",
          "size": "1Gi",
          "deleteClaim": true
        },
        config: {
          "offsets.topic.replication.factor": 1,
          "transaction.state.log.replication.factor": 1,
          "transaction.state.log.min.isr" : 1,
          "default.replication.factor": 3,
          "min.insync.replicas": 2
        }
      },
      "zookeeper" = {
        "replicas": 3,
        "storage": {
          "type": "persistent-claim",
          "size": "1Gi",
          "deleteClaim": true
        },
      }
    }
  }
}
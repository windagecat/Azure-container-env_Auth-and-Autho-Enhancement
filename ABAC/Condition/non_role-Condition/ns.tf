resource "kubernetes_namespace" "ns" {
  count  = length(local.teams) - 1
  metadata {
    name = lower(local.teams[count.index])
  }
}
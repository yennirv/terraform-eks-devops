resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = var.cluster_name
  addon_name        = each.value.name
  addon_version     = each.value.version
#  resolve_conflicts = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  timeouts {
  create = "40m"
  update = "40m"
  delete = "40m"
  }
  depends_on = [ aws_eks_cluster.demo_eks ]
}
/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "google_client_config" "client" {}

data "google_client_openid_userinfo" "terraform_account" {}

data "google_container_cluster" "cluster" {
  project  = var.project
  name     = var.name
  location = var.location
}

resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${data.google_container_cluster.cluster.name} --region ${data.google_container_cluster.cluster.location} --project ${data.google_container_cluster.cluster.project}"
    environment = {
      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
    }
  }
}

resource "kubernetes_cluster_role_binding" "terraform_account" {
  metadata {
    name = "admin-user"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = data.google_client_openid_userinfo.terraform_account.email
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [null_resource.configure_kubectl]
}

resource "helm_release" "applications" {
  for_each         = var.helmchart_applications
  name             = each.value.name
  repository       = each.value.repository
  chart            = each.value.chart
  namespace        = each.value.namespace
  create_namespace = each.value.create_namespace

  depends_on = [kubernetes_cluster_role_binding.terraform_account]
}

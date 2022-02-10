## Copyright 2019 Google LLC

# Copyright 2021 Google LLC. This software is provided as is, without
# warranty or representation for any use or purpose. Your use of it is
# subject to your agreement with Google.


import os
from google.cloud.devtools import cloudbuild_v1

client = cloudbuild_v1.services.cloud_build.CloudBuildClient()

def validate(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
        event (dict): Event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """

    build = cloudbuild_v1.Build()

    core_org_id = os.environ.get('ORG_ID')
    project_id = os.environ.get('PROJECT_ID')
    region_name = os.environ.get('REGION')
    trigger_branch = os.environ.get('BRANCH')
    csr_repo_name = os.environ.get('REPO_NAME')
    asset_inventory_bucket_name = os.environ.get('ASSET_INVENTORY_GCS_BUCKET')
    guardrails_artifact_registry_name = os.environ.get('GUARDRAILS_ARTIFACT_REGISTRY_NAME')
    guardrails_report_bucket_name = os.environ.get('GUARDRAILS_REPORTS_GCS_BUCKET')
    guardrails_report_bucket_name_suffix = os.environ.get('GUARDRAILS_REPORTS_GCS_BUCKET_SUFFIX')
    guardrails_policies_container_name = os.environ.get('GUARDRAILS_POLICIES_CONTAINER_NAME')
    guardrails_policies_container_tag = os.environ.get('GUARDRAILS_POLICIES_CONTAINER_TAG')

    folder = event['name'].split('/')[0]
    filename = event['name'].split('/')[1]
    inventory_org_id = filename.split('.')[0]

    build.steps = [
        {
            "name": "gcr.io/cloud-builders/gcloud",
            "args": ["cp","gs://{}/{}".format(asset_inventory_bucket_name,event['name']),"/assets/asset_inventory.json"],
            "entrypoint": "gsutil"
        },
        {
            "name": "gcr.io/cloud-builders/docker",
            "args": ["-c","cp /assets/asset_inventory.json assets"],
            "entrypoint": "bash"
        },
        {
            "name": "gcr.io/cloud-builders/docker",
            "args": ["run","-v","/workspace/guardrails-validation:/app","{}-docker.pkg.dev/{}/{}/{}:{}".format(region_name,project_id,guardrails_artifact_registry_name,guardrails_policies_container_name,guardrails_policies_container_tag)],
        },
        {
            "name": "gcr.io/cloud-builders/docker",
            "args": ["-c","cat report.txt"],
            "entrypoint": "bash"
        },
        {
            "name": "gcr.io/cloud-builders/docker",
            "args": ["-c","cp report.txt /assets/{}".format(filename)],
            "entrypoint": "bash"
        },
        {
            "name": "gcr.io/cloud-builders/gcloud",
            "args": ["cp","/assets/{}".format(filename), "gs://{}/{}/{}.txt".format(guardrails_report_bucket_name,folder,inventory_org_id)],
            "entrypoint": "gsutil"
        }
    ]

    # Send to remote bucket if scanning remote organization
    if core_org_id.strip() != inventory_org_id.strip():
        remote_report_bucket_name = "{}-{}".format(inventory_org_id,guardrails_report_bucket_name_suffix)
        build.steps.append({
            "name": "gcr.io/cloud-builders/gcloud",
            "args": ["cp","/assets/{}".format(filename), "gs://{}/{}/{}.txt".format(remote_report_bucket_name,folder,inventory_org_id)],
            "entrypoint": "gsutil"
        })

    build.options = {
        "volumes": [
            {
                "name": "assets",
                "path": "/assets"
            }
        ]
    }

    build.source = {
        "repo_source":{
            "project_id": project_id,
            "repo_name": csr_repo_name,
            "branch_name": trigger_branch,
            "dir_": "guardrails-validation"
        }
    }

    result = client.create_build(project_id=project_id, build=build)
    return result
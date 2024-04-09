# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



import os
from google.cloud import asset_v1

client = asset_v1.AssetServiceClient()

def scan(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    parent = []
    parent.append(os.environ.get('PARENT'))
    asset_inventory_bucket = os.environ.get('ASSET_INVENTORY_GCS_BUCKET')
    output_config = asset_v1.OutputConfig()
    content_type = asset_v1.ContentType.RESOURCE
    gs_path = "gs://{}/".format(asset_inventory_bucket)
    error_list = []
    for org_id in parent:
        try:
            output_config.gcs_destination = {"uri":gs_path + "{}.json".format(org_id)}
            client.export_assets({
                "parent":org_id,
                "output_config":output_config,
                "content_type": content_type
            })
        except Exception as err:
            error_list.append(org_id)
            print(org_id+":"+str(err))
            continue

    success = list(set(parent) - set(error_list))
    print("Successfully triggered asset report generation for:", success)
    print("Error List:", error_list)

    return "OK!"

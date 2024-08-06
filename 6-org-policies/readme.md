1. Org policies are implemented in 1-Org Folder at path - /../TEF-GCP-LZ-HS/1-org/envs/shared/org_policy.tf

2. In total 26 Org Policies have been implemented and details of the same can be found out in the shared TDD under Org Policies section with granular details in the "Security Controls" sheet.

3. Once the policies are implemented at 1-Org level, developer can use the "6-org-policies" package to customize policies whether they are needed or are to be overriden at environment specific level.

4. The sub folder in the directory and their details are as follows-
    -> common:- This is where env agnostic policies can be placed or overriden. In a simple way if there is a requirement to implement or over ride a policy for all env together then that can be done in "common" folder

    -> development: If there is a requirement to implement a new or over ride an org policy for "development" environment then that can be done in this folder

    -> identity: If there is a requirement to implement a new or over ride an org policy for "identity" environment then that can be done in this folder

    -> management: If there is a requirement to implement a new or over ride an org policy for "management" environment then that can be done in this folder

    -> nonproduction: If there is a requirement to implement a new or over ride an org policy for "nonproduction" environment then that can be done in this folder

    -> production: If there is a requirement to implement a new or over ride an org policy for "production" environment then that can be done in this folder

5. All the environment specific terraform deployment have separate state files to shield them from each other and reduce blast radius in case of human mistake. They are stored in GCP bucket as backend for Terraform

6. remote.tf file is used to recall values of previously deployed resources which were deployed in the preceeding modules

7. The existing setup of Org Policies are done to be in compliance with expected security standards of PBRR, any changes in the production code may result in noncompliance of some controls. It is recommended that you make changes to this codeonly after aligning with a security expert

8. As requested by MCN we have overriden most of the policies at DEV level folder so that it becomes easy for the users to experiment.
## Table Of Contents
| ID | Category |
| --- | --- |
| 0 | [New Google Account Prerequisites](#new-google-cloud-account-prerequisites) | 
| 1 | [Onboarding Category 1: Workspace Account - Domain hosted on Google Domains](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-1-workspace-account---domain-hosted-on-google-domains) |
| 2 | Onboarding Category 2: 3rd party email account - GCP Domain validation |
| 2b | Onboarding Category 2b: 3rd party email account - GCP admin only domain validation - no hosted domain zone |
| 3 | [Onboarding Category 3: Gmail Account with forwarding - Domain hosted on Google Domains](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-3-gmail-account---domain-hosted-on-google-domains) |
| 3b1 | [Onboarding Category 3b1: 3rd party email account - 3rd party (AWS Route53) domain validation - reuse existing billing account](#onboarding-category-3b1-3rd-party-email-account---3rd-party-aws-route53-domain-validation---reuse-existing-billing-account) |
| 5c | [Onboarding Category 5c: second 3rd party Email - 3rd party Domain already verified](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-5-3rd-party-email---3rd-party-domain) |
| 9 | Onboarding Category 9: Consumer Gmail account - no Domain |
|  | [Onboarding Accounts and Projects Structure](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-accounts-and-projects-structure) |
| 10 | [Onboarding 10: Workaround for DENY flagged domain during repeated Cloud Identity User creation](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#category-10-workaround-for-deny-flagged-domain-during-cloud-identity-creation) |
| 11 | [Onboarding 11: Onboarding without access to the domain zone - variant use case](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#category-11-onboarding-without-access-to-the-domain-zone---variant-use-case) |
|  | |
| 12 | [Onboarding 12: Identity User Suspension on org creation or import - safely ignore this red herring](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-12-new-cloud-identity-users-are-flagged-as-user-suspended-by-default-in-admin-security-alert-center---ignore---this-is-a-red-herring) |
|  | [Billing](#billing) |

---
# References

Creation of a GCP Organization including either a Workspace or Cloud Identity account - https://cloud.google.com/resource-manager/docs/creating-managing-organization.  If projects and their billing ID association are created before a domain and organization are added - these projects can be migrated via https://cloud.google.com/resource-manager/docs/migrating-projects-billing


# New Google Cloud Account Prerequisites

Note: this document is for initial Cloud Identity - Super Admin accounts. For production deployments, usually identity federation will be used.  See Identity Onboarding and Federation options at https://cloud.google.com/architecture/landing-zones/decide-how-to-onboard-identities

When creating a new google cloud account the following artifacts will be required.

- One or more existing billing account IDs or access to a credit card that will be associated with a new billing account
- An existing or new email for use as the "Primary Admin" in https://admin.google.com/ac/accountsettings and as the "Super Admin" role in https://admin.google.com/ac/roles/53389702564151297
- An existing or new domain for organization DNS validation

There is a special IAM role that will need to be added to both any new super admin level users beyond the original SA root account and any service accounts used during automated deployments involving new projects that require associated billing permissions to link a billing account to projects.  In addition to the "Project Billing Manager" we need to set the "Billing Account Administrator"

In the following screen capture - this is a new GCP account where the "root" account was automatically added to the billing permission side in billing : https://console.cloud.google.com/billing. Any additional admin users are added automatically to the billing side if they are added in IAM.  Notice that the root account is not set in IAM but is set in billing.

<img width="1882" alt="_billing_account_administrator_role_new_account_both_iam_and_billing" src="https://user-images.githubusercontent.com/94715080/174884634-7d32a255-014d-4252-95ad-ee5005d73127.png">

---

# Google Cloud Account post-onboarding Guardrails or Landing Zone deployment

After your organization has been created, we recommend that one of the following guardrails or landing zone deployments depending on the security profile of your projects and/or organization

## Google Cloud Guardrails and Landing Zone options

**https://github.com/canada-ca/accelerators_accelerateurs-gcp - 30 day Guardrails**

**https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding - PBMM landing zone**

Determining which set of guardrails or landing zone to use will depend on your cloud profile use case https://github.com/canada-ca/cloud-guardrails/blob/master/EN/00_Applicable-Scope.md#cloud-usage-profiles (Level 1 for private only sandboxes all the way to Level 6 for PBMM (Protected B Medium Integrity / Medium Availability - with or without SCED/SC2G - see slide 18-19 of https://wiki.gccollab.ca/images/7/75/GC_Cloud_Connection_Patterns.pdf)

We recommend either the 30 day Guardrails https://github.com/canada-ca/accelerators_accelerateurs-gcp or the full PBMM landing zone https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding for profile 1 to 2 or prototyping work.  We recommend the full PBMM landing zone https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding for profile 2 to 6.

**https://github.com/canada-ca/accelerators_accelerateurs-gcp - 30 day Guardrails**

**https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding - PBMM landing zone**

https://github.com/canada-ca/cloud-guardrails-gcp/tree/main/guardrails-validation - 30 day Guardrails validation

https://github.com/canada-ca/cloud-guardrails/tree/master/EN - Guardrails controls documentation

### Additional Onboarding Templates and SDKs

https://cloud.google.com/anthos-config-management/docs/tutorials/landing-zone - Config Controller Anthos based Landing Zone blueprint

https://cloud.google.com/docs/terraform/blueprints/terraform-blueprints#blueprints - Terraform based SDK blueprints off the Cloud Foundation Toolkit https://cloud.google.com/foundation-toolkit

Example Log Sinks https://github.com/terraform-google-modules/terraform-google-log-export

https://cloud.google.com/docs/security/infrastructure/design

https://cloud.google.com/architecture/security-foundations

https://cloud.google.com/vpc-service-controls/docs/secure-data-exchange

https://cloud.google.com/security/compliance/offerings#/regions=Canada

---

## Onboarding Category 1: Workspace Account -  Domain hosted on Google Domains

Follow the next steps if:
* You are a new customer and require a new domain

This scenario will guide you through the steps to purchase an available domain from Google Domains and create a new Workspace account.

Perform the following steps in an Incognito Window.

To create a new Google Workspace account follow the next steps:
* Go to https://workspace.google.com/business/signup/welcome.
* Entre your Business Name.
* Select “Just you” under Number of employees. You can add more users later.
* Ensure “Canada” is selected as the Region.
* Click “Next”.

<img width="1770" alt="Screen Shot 2022-06-05 at 08 29 35" src="https://user-images.githubusercontent.com/24765473/172050451-ac9d24e0-980f-49d1-ac0d-fab492618e44.png">

* Enter the info for the Google Workspace account administrator and your current email address.
* Click “Next”.

<img width="1766" alt="Screen Shot 2022-06-05 at 08 30 36" src="https://user-images.githubusercontent.com/24765473/172050528-75b8927b-8b55-4999-83fb-ce1da20e78b6.png">

* On the next screen, select “No, I need one” to purchase a new domain.

<img width="1778" alt="Screen Shot 2022-06-05 at 08 31 21" src="https://user-images.githubusercontent.com/24765473/172050562-f5a3b75d-575a-417a-8528-6e9356eea83a.png">

* Search for an available domain name and click on the domain name entry or the “>” arrow.

<img width="1772" alt="Screen Shot 2022-06-05 at 10 16 36" src="https://user-images.githubusercontent.com/24765473/172055017-970f3972-1981-479e-9d87-542ad53ec276.png">

* Click “Next”.

<img width="1775" alt="Screen Shot 2022-06-05 at 10 17 59" src="https://user-images.githubusercontent.com/24765473/172055035-f9262497-08a8-47b3-b00d-b705e52c47b2.png">

* Enter your business information and click “Next”.
* Select if you would like to receive tips, offers and announcements.
* Select if you would like your users to receive information and tips about Google Workspace.
* Create your first user, which will be granted the Workspace Super Admin role. Click “Agree and continue”.

<img width="1767" alt="Screen Shot 2022-06-05 at 10 19 16" src="https://user-images.githubusercontent.com/24765473/172055093-8f4a2b6c-fd20-4d71-a2f0-6a58e35efaef.png">

* Review your payment plan and click “Next”.

<img width="1777" alt="Screen Shot 2022-06-05 at 10 20 03" src="https://user-images.githubusercontent.com/24765473/172055124-676d384c-5ac9-40a9-ba1d-baded5d78d06.png">

* Enter the payment details and select if you would like to automatically renew your domain registration every year. Click “Next” to finalize the creation of your Workspace account.

<img width="1773" alt="Screen Shot 2022-06-05 at 10 21 18" src="https://user-images.githubusercontent.com/24765473/172055180-bed23bc6-ad6f-421d-ab1f-ef6ad16c2025.png">

* Click “Continue to admin console”.

<img width="1772" alt="Screen Shot 2022-06-05 at 10 22 06" src="https://user-images.githubusercontent.com/24765473/172055236-f34015e4-8567-42d9-96bf-3f62c0fdf3cd.png">

**Important**: Check your email inbox and respond to the email asking you to verify your contact information. This is required by ICANN (the governing body for domain registration) to complete domain registration. After you purchase a domain, you'll receive an email to verify your email address. You must verify your email address within 15 days. Otherwise, your domain won't be registered and you can't use it for email and other services.

<img width="773" alt="Screen Shot 2022-06-05 at 11 08 14" src="https://user-images.githubusercontent.com/24765473/172057273-09a32553-83e0-4d2f-8ddf-96d3cafba3f8.png">

Workspace account validation steps:
* In the admin console, you will see the alert “Domain registration is pending” (as shown below) if you haven’t responded to the email that was sent to you after purchasing the domain. If you haven’t done so, please verify your email address by opening the email sent by Google Domains and clicking “Verify email now”.

<img width="1774" alt="Screen Shot 2022-06-05 at 10 22 32" src="https://user-images.githubusercontent.com/24765473/172055244-b3638c99-544e-4f4c-a145-d519976c7e49.png">

* To check your service subscriptions, go to Billing -> Subscriptions. Verify you have: Domain Registration and Google Workspace.

<img width="1775" alt="Screen Shot 2022-06-05 at 10 23 32" src="https://user-images.githubusercontent.com/24765473/172055284-ec163002-927e-4f93-bb97-1b23c62c0bb0.png">

* Go to Account -> Admin Roles to validate that your admin account was added to the Super Admin role. 

<img width="1677" alt="Screen Shot 2022-06-05 at 10 29 08" src="https://user-images.githubusercontent.com/24765473/172055573-32d5995e-cf96-428d-858a-1b7a276454f5.png">

The following steps will guide you through the onboarding of your GCP organization:
* Go to http://console.cloud.google.com 
* Select “Canada” as Country, check the Terms of Service and click “Agree and continue”.

<img width="1679" alt="Screen Shot 2022-06-05 at 10 30 19" src="https://user-images.githubusercontent.com/24765473/172056451-b54af622-7067-4318-bbfd-bc892993b8a8.png">

* Activate your Free Trial by clicking the “Activate” button at the top-right side of the screen.

<img width="1671" alt="Screen Shot 2022-06-05 at 10 30 52" src="https://user-images.githubusercontent.com/24765473/172056460-9a9af020-a442-4f46-8872-e2731da04251.png">

* Enter the account and payment information required. These steps will set up your Billing Account.

<img width="1677" alt="Screen Shot 2022-06-05 at 10 33 10" src="https://user-images.githubusercontent.com/24765473/172056504-fd3c7fdd-117a-4740-a008-c3d5df453f40.png">

<img width="1673" alt="Screen Shot 2022-06-05 at 10 33 39" src="https://user-images.githubusercontent.com/24765473/172056510-0a805854-16d1-45ae-a53e-a4a330f5216e.png">

<img width="1675" alt="Screen Shot 2022-06-05 at 10 34 12" src="https://user-images.githubusercontent.com/24765473/172056521-4dda0433-d8b2-4d9c-ac2a-8a8487e0f181.png">

<img width="612" alt="Screen Shot 2022-06-05 at 10 35 08" src="https://user-images.githubusercontent.com/24765473/172056531-870bf9d7-c027-44e0-bf5f-246c4a65a933.png">

* Answer the survey and click “Done”.

<img width="1678" alt="Screen Shot 2022-06-05 at 10 35 40" src="https://user-images.githubusercontent.com/24765473/172056541-af79f786-d0dc-43ad-b258-ea0114b27785.png">

GCP validation steps:
* On the GCP console, go to IAM & Admin -> Identity & Organization.
* Click the button “Go to the checklist”.

<img width="1674" alt="Screen Shot 2022-06-05 at 10 31 40" src="https://user-images.githubusercontent.com/24765473/172056470-e70236d6-3654-436f-aeba-688eb0925c92.png">

* Ensure you have the permissions to perform certain admin actions in the console as shown below.

<img width="1676" alt="Screen Shot 2022-06-05 at 10 31 51" src="https://user-images.githubusercontent.com/24765473/172056476-9fd454a6-6234-4eb2-b56b-34615252c1a3.png">

* Click "Cloud Identity & Organization" (on the left menu) and validate that this task/step has been completed.
* Go to IAM & Admin -> IAM to validate the permissions for your organization. Make sure that the name of your organization is selected. It should be displayed at the top of the screen, to the left of the Search field.

<img width="1668" alt="Screen Shot 2022-06-05 at 10 46 26" src="https://user-images.githubusercontent.com/24765473/172056383-0f11aa21-8352-4712-9376-edbed2043f53.png">

* Review the default roles at the organization level and grant your admin user the roles: Owner and Folder Admin.

<img width="1662" alt="Screen Shot 2022-06-05 at 10 57 09" src="https://user-images.githubusercontent.com/24765473/172056846-a796853f-b7e6-4edd-98c3-5b8fb45c3791.png">

* To validate the Folder Admin role, create a Test Folder under your organization.
* Enter "Manage Resources" on the Search field at the top of the screen. Select "Manage Resouces".
* Click "Create Folder".
* Enter the required information and make sure that your organization is selected under "Organization" and "Location". Click "Create"

<img width="1667" alt="Screen Shot 2022-06-05 at 10 57 57" src="https://user-images.githubusercontent.com/24765473/172056857-8f2f0460-7411-4f3c-888f-e9db02ebada0.png">

* Refresh the page to see the new folder.

<img width="1675" alt="Screen Shot 2022-06-05 at 10 58 27" src="https://user-images.githubusercontent.com/24765473/172056860-112e00f3-91ad-4b9a-bc82-fc3ff52a5261.png">

* On the same screen, validate that you can create projects under the folder created in the previous step.
* Click "Create Project".
* Enter the required information and make sure that your organization is selected under "Organization", and the folder previously created is selected under "Location". Click "Create".

<img width="1671" alt="Screen Shot 2022-06-05 at 11 02 46" src="https://user-images.githubusercontent.com/24765473/172057009-3bed2530-d3c7-45fe-9f87-87b10fa3e369.png">

### Quota Increase

By default, a Billing Account can only be linked to a certain number of projects, based on a variety of factors. A temporary workaround is to create additional billing accounts to get quota per account - or associate an existing billing account from another organization - see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-3b1-3rd-party-email-account---3rd-party-aws-route53-domain-validation---reuse-existing-billing-account

To submit a quota increase follow the next steps:
* Fill out the billing quota increase from the default 5 directly via https://support.google.com/code/contact/billing_quota_increase
* Fill out the project quota increase from the default 20 directly viahttps://support.google.com/code/contact/project_quota_increase
* or
* Create (at least) 5 projects, or more, under the folder created in the GCP validation steps section.
* On the left menu, go to Billing and select “My Projects”. Notice that the last project has billing disabled.
* In the Actions column, click the "More Actions" (3 dots) icon corresponding to the project. Select “Change Billing”. 

<img width="1670" alt="Screen Shot 2022-06-05 at 11 04 01" src="https://user-images.githubusercontent.com/24765473/172057176-2b2d3ba4-63e4-417c-80f8-ea04001920e3.png">

* Select a Billing account and click “Set Account”.

<img width="513" alt="Screen Shot 2022-06-05 at 11 04 32" src="https://user-images.githubusercontent.com/24765473/172057181-132ecd4e-8cc7-42d9-a1cb-1c585c8a3472.png">

* The following message will appear. Select “Request Quota Increase”. 

<img width="555" alt="Screen Shot 2022-06-05 at 11 04 39" src="https://user-images.githubusercontent.com/24765473/172057185-ad218feb-6187-4846-b407-f0aeffc1782f.png">

* Provide the required information and submit the quota increase request.

<img width="1663" alt="Screen Shot 2022-06-05 at 11 05 45" src="https://user-images.githubusercontent.com/24765473/172057188-1260a4f6-82b3-4d9c-b156-654678f1ff9a.png">

<img width="1660" alt="Screen Shot 2022-06-05 at 11 05 55" src="https://user-images.githubusercontent.com/24765473/172057198-860fa182-e4b7-487d-9ba5-9f944dcf76be.png">

Instead of submitting a Quota Increase request, you can also create another Billing Account.
* Go to Billing, select “My Billing Accounts” and click “Create Account”.
* Provide the payment information required.

<img width="1665" alt="Screen Shot 2022-06-05 at 11 24 46" src="https://user-images.githubusercontent.com/24765473/172058013-9aa6fac3-58de-441a-8c76-2ba17f0cd95f.png">

<img width="1667" alt="Screen Shot 2022-06-05 at 11 25 16" src="https://user-images.githubusercontent.com/24765473/172058016-6d6e8cfd-37a6-48eb-87c1-1e6e820369a3.png">

### Increasing Quotas
Ask for 20 from the default 5 for project/billing association - create 6 projects and assign billing on the 6th to get the popup.
Select "paid services" and you will get approved in 3 min.




## Onboarding Category 2: 3rd party Email -  GCP Domain

This category is where the client uses their own email system but has the organization domain with GCP

## Onboarding Category 3: Gmail Account -  Domain hosted on Google Domains


Creation of a GCP Organization including either a Workspace or Cloud Identity account - https://cloud.google.com/resource-manager/docs/creating-managing-organization.  If projects and their billing ID association are created before a domain and organization are added - these projects can be migrated via https://cloud.google.com/resource-manager/docs/migrating-projects-billing

Follow the next steps if:
* You are a new customer using a Gmail account with optional redirect records on an existing Google Domains hosted domain for your organization.

This scenario will guide you through the steps to create a required Cloud Identity account (using a Gmail account) and a subdomain for an existing Google Domains managed domain. 

In this scenario the Gmail account is a formality. You can also use your own 3rd party email account.

Perform the following steps in an Incognito Window.

To create a Cloud Identity account follow these steps:
* Go to https://accounts.google.com/SignUpWithoutGmail.
* Enter the information required.
* Select “Create a new Gmail address instead”.

<img width="1500" alt="3-3" src="https://user-images.githubusercontent.com/94715080/169103623-f0628cf6-627b-4373-9cf5-186813aca0e6.png">

* Enter the account details.
* Click “Next”.

<img width="1166" alt="3-5" src="https://user-images.githubusercontent.com/94715080/169103739-d0c14b66-a68a-48f1-841e-b2a81aa9620e.png">

* Follow the steps to Verify your phone number.

<img width="1518" alt="3-6" src="https://user-images.githubusercontent.com/94715080/169103768-3a1db456-d4bb-4d7d-85d5-9b187a50dedc.png">

* Confirm that your account has been created.

<img width="484" alt="3-7" src="https://user-images.githubusercontent.com/94715080/169103836-125c5eb5-b0c3-406c-bf20-3b243567d079.png">

The following steps will guide you through the onboarding of your GCP organization:
* Go to https://console.cloud.google.com and login with the account you created in the previous steps.
* Check the “Terms of Service” and click “Agree and Continue”.

* Go to IAM & Admin -> Identity & Organization.
* Click “Go to the Checklist”.
    *You will see a message stating that your current account is not associated with an organization on Google Cloud.*

<img width="886" alt="3-17" src="https://user-images.githubusercontent.com/94715080/169104114-f3773a09-d800-4721-ac02-651429791332.png">

* Click “Begin the setup”.

<img width="1516" alt="3-18" src="https://user-images.githubusercontent.com/94715080/169104355-35c904c0-4080-4188-a85f-6ba6aee68ccc.png">

* On the “Cloud Identity & Organization” screen, scroll down and select “I’m a new customer”.

<img width="1526" alt="3-19" src="https://user-images.githubusercontent.com/94715080/169104384-965f7e9a-c824-4d87-8d34-9c35f820bfea.png">

* Click “Sign up for Cloud Identity”.

<img width="585" alt="3-20" src="https://user-images.githubusercontent.com/94715080/169104428-0fb2fd1f-c1dd-4e48-a88c-413a6de0a63b.png">

* On the Cloud Identity wizard, click “Next”.

<img width="1520" alt="3-21" src="https://user-images.githubusercontent.com/94715080/169104574-ce544af5-d3ad-44c3-8471-1a85263987eb.png">

* Enter the Business Name and select “Just you” under Number of employees.
* Click “Next”.

<img width="1512" alt="3-22" src="https://user-images.githubusercontent.com/94715080/169104598-a2c16544-f9fe-4f8c-86d0-52aa84773e2c.png">

* Select the country where your business is located. Click "Next".
* Enter the Gmail account that you just created. Click “Next”.
    *Note: You can also use your own email.*

<img width="1518" alt="3-23" src="https://user-images.githubusercontent.com/94715080/169104631-cc293b2a-e1fc-4c26-80f5-4ad90c8001e0.png">

* Enter your domain name.
    *Note: Make sure you enter the name for a (new) subdomain (gcp.**).  *For example: gcp.gcloud.network*

<img width="1516" alt="3-24" src="https://user-images.githubusercontent.com/94715080/169104653-f6395cb7-25e9-4b87-967d-7d91fa0ff772.png">

* Click “Next” to confirm the domain you want to use to set up the account.
    *Notice the warning on email redirection - we will set this up in the domain owner account.*

<img width="1522" alt="3-25" src="https://user-images.githubusercontent.com/94715080/169104692-ed482a0c-df15-4d1e-822e-da2994732b3f.png">

* Click "Next" to go to the next screen.
* You will come back to this screen after the following section.

In another window, follow the next steps to verify the domain:
* Go to  https://domains.google and login with the account that owns the domain. In this case: gcloud.network.
* Select the domain, click "Manage" and go to “Email”.
    *Notice there is no email forwarding record yet.*

<img width="1528" alt="3-26a" src="https://user-images.githubusercontent.com/94715080/169104721-59836309-d048-4f3e-9afd-830898abc20a.png">

* Click "Add email alias".
* Enter the Email Forwarding information.
    *Use a “super admin” alias - an account will be created later with this alias.*
* Click “Add”.

<img width="1520" alt="3-27a" src="https://user-images.githubusercontent.com/94715080/169104792-b200b423-421c-40ac-925b-316ba0090b41.png">

* In your Gmail account inbox you will receive the following email to verify your email forwarding address.
* Click the “Verify my email now” button.

<img width="1530" alt="3-29" src="https://user-images.githubusercontent.com/94715080/169104932-a648f8cd-cdee-405e-a16f-d2accb228921.png">

To verify the redirect follow these steps:
* Send an email to the new super admin account.

<img width="597" alt="3-31" src="https://user-images.githubusercontent.com/94715080/169105169-40e6cb6d-6a21-45b1-b5e7-1e24f490009a.png">

* Verify that the email was forwarded to the Gmail account.

<img width="1530" alt="3-32" src="https://user-images.githubusercontent.com/94715080/169105205-b0b2f165-2d48-4b03-be27-531a71692f78.png">

Back on the Cloud Identity wizard:
* On the “What’s your name?” screen, enter the information for the account administrator. Click “Next”.

<img width="1523" alt="3-33" src="https://user-images.githubusercontent.com/94715080/169105684-31f9cd8d-3acc-4a8c-a719-42f255020e60.png">

* Enter the username and password for the super admin account of your new subdomain.

<img width="1522" alt="3-34" src="https://user-images.githubusercontent.com/94715080/169105720-ce76b314-b457-4adb-905e-f339483d62d0.png">

* Select if you would like to receive tips, offers and announcements..

<img width="1516" alt="3-35" src="https://user-images.githubusercontent.com/94715080/169106023-7dc58527-f9b5-4697-ac68-b50cde6dd18e.png">

* Select if you would like your users to receive information and tips about Google Workspace.
* Go through the reCAPTCHA challenge and click “Agree and Create Account”.

<img width="1523" alt="3-36" src="https://user-images.githubusercontent.com/94715080/169106716-2bb6b24e-9db4-41a6-a44c-30d37ea447b0.png">

* Click “Go to Setup”.

<img width="1528" alt="3-37" src="https://user-images.githubusercontent.com/94715080/169106752-f66d6e2d-3356-4338-9e07-8d627ae1dad3.png">

* Sign in using the new super admin account in your subdomain.

<img width="1527" alt="3-38" src="https://user-images.githubusercontent.com/94715080/169106802-078b0541-2503-46cc-9d83-b8234e2baffa.png">

* Follow the steps to Verify your identity.

<img width="1526" alt="3-39" src="https://user-images.githubusercontent.com/94715080/169106856-5c00ff98-047d-4b10-a412-ecbda7682a04.png">

<img width="1518" alt="3-40" src="https://user-images.githubusercontent.com/94715080/169106882-abac7b23-b2ae-4383-ac9d-eb387008546c.png">

* Click “Accept”.

<img width="1524" alt="3-41" src="https://user-images.githubusercontent.com/94715080/169106910-053b28ae-014e-4e65-a6d2-5d93a7d3f281.png">

* Click “Next”.

<img width="1522" alt="3-42" src="https://user-images.githubusercontent.com/94715080/169106937-df59e280-58bd-4a82-9008-dfe68f13da8d.png">

* Click “Verify” to verify the new subdomain.

<img width="1518" alt="3-43" src="https://user-images.githubusercontent.com/94715080/169106989-c31d1a78-e34e-4f98-a1a2-71719794f488.png">

* Click “Or switch verification method”.

<img width="1524" alt="3-44" src="https://user-images.githubusercontent.com/94715080/169107030-34f7d874-04ad-4af1-af12-e3d663964c77.png">

* Select “Create a TXT record (Recommended)”.
* Click “Next”.

<img width="1526" alt="3-45" src="https://user-images.githubusercontent.com/94715080/169107063-36ebe5e2-a056-48e2-a0bf-c105e63d86e2.png">

* On the next screen, follow the instructions to add your verification code:

<img width="1520" alt="3-47" src="https://user-images.githubusercontent.com/94715080/169107129-e719024c-69fb-4551-b446-a0553b348315.png">

* Go to https://domains.google and login with the account that owns the domain (gcloud.network).
* Select the domain you want to verify, click “Manage” and select “DNS”.
* In the “Custom records” section, enter the host name, set Type to TXT, set TTL to 3600 (or 1 hour) and paste the TXT verification code copied previously.
* Click “Save".

<img width="1523" alt="3-49a" src="https://user-images.githubusercontent.com/94715080/169107211-e41f7b9a-0cab-498a-a9cc-affc8c9ad7ad.png">

<img width="1528" alt="3-50a" src="https://user-images.githubusercontent.com/94715080/169107234-259efa61-2f12-45ed-b5b8-c461363dedf2.png">

* Back on the “Verify your domain” screen, click “Verify my domain”. This will take a few minutes.

<img width="1525" alt="3-51" src="https://user-images.githubusercontent.com/94715080/169107271-5fa60041-401a-4663-8bd1-76793aeb5ea1.png">

* Run a dig on the subdomain.

<img width="989" alt="3-53b" src="https://user-images.githubusercontent.com/94715080/169107335-bd1c494f-8a28-49e7-99e3-0e3bda996325.png">

* The Cloud Identity wizard will update when the domain has been verified.
* Click “Set up GCP Cloud Console now”. Make sure you are logged in with your new Cloud Identity super admin account.

<img width="1522" alt="3-54" src="https://user-images.githubusercontent.com/94715080/169107353-ae578ac5-4141-47c1-833e-018b1f6b4806.png">

* Check the “Terms of Service” and click “Agree and Continue”.

<img width="1524" alt="3-55" src="https://user-images.githubusercontent.com/94715080/169107401-ea5d8135-ecd8-4a98-bf07-f8b469cc22e3.png">

* Go to IAM & Admin -> IAM.
    *Notice that the GCP organization will be automatically created.*

<img width="609" alt="3-56" src="https://user-images.githubusercontent.com/94715080/169107437-65dce692-75b3-49e5-9ada-2f27c35da02d.png">

* Click on "Select a project" at the top of the screen. 
* Select the new organization in the “Select from” dropdown box. 

<img width="1528" alt="3-63b" src="https://user-images.githubusercontent.com/94715080/169107680-f7b9af00-d1f5-4556-8653-91f465b10e99.png">

* The new organization should be visible in the "All" tab.

<img width="1531" alt="3-64b" src="https://user-images.githubusercontent.com/94715080/169107702-1ff52a02-a630-42f2-ba09-4feb7fb077c1.png">

### Validate that the Super Admin user has been granted the Organization Administrator role.

<img width="1529" alt="3-65b" src="https://user-images.githubusercontent.com/94715080/169107734-e6cdedd6-872e-4166-9689-3ceb3bbc6b68.png">

## Onboarding Category 3b1: 3rd party email account - 3rd party (AWS Route53) domain validation - reuse existing billing account

There are several ways to add a shared billing account - email push/pull - but the 3rd - just adding the identity user in the 2nd organization as a Billing Administrator in the organization owning the billing id works ok.  
This method also reproduces the state we see where the shared billing id shows up only under “no organization : id=0” but is automatically added to new projects in the target org ok.  

So we have a way to simulate the billing provisioning using 2 separate organizations.

- 20220802
- follow https://cloud.google.com/identity/docs/set-up-cloud-identity-admin and select Cloud Identity Free https://workspace.google.com/signup/gcpidentity/welcome#0
- In this case we wish to use a pre-existing billing account

### Requirements
- 3 personas required
- - Cloud Identity user (a super admin (usually the first user of the target account) - the user that will onboard the organization via https://workspace.google.com/signup/gcpidentity/welcome#0
- - Billing Account Administrator (source account) - the user who will add the account name (identity email) of the super admin of the target account above
- - Owner of the domain zone (to be able to apply the domain verification TXT record during organization onboarding by the target super admin above)
- 
- The Super Admin of the target account must have access to the Domain zone (even if it is sending a mail to the IT/Domain-zone owner) - to be able to set the organization subdomain TXT record for domain validation
- Billing account admin of the owning billing account must set the target Identity account as the Billing Account Administrator (full landing zone rights) - or Billing User, Billing Viewer (for single projects)

### Procedure
- create/use new 3rd party email account matching at least the TLD - in this case an AWS Workmail account under eventstream.io
- create new Cloud Identity account - user@gcp.eventstream.io with domain gcp.eventstream.io - specifically via https://workspace.google.com/signup/gcpidentity/welcome#0
- validate domain via TXT record on AWS route 53
- login to the cloud console at console.cloud.google.com
- request to move billing accounts in IAM or add the target user as a billing admin in the source/owner organization

todo: caption the screencaps below

<img width="931" alt="Screen Shot 2022-08-02 at 20 58 44" src="https://user-images.githubusercontent.com/24765473/182519338-9b1d3e62-fae7-47ca-bb28-17da72302f9f.png">

<img width="1294" alt="Screen Shot 2022-08-02 at 20 59 00" src="https://user-images.githubusercontent.com/24765473/182519365-57be07c0-44c1-41b3-9658-0a173a1f780e.png">

<img width="1078" alt="Screen Shot 2022-08-02 at 21 01 08" src="https://user-images.githubusercontent.com/24765473/182519406-b1de4660-527d-4aa7-8e4d-cbbf0426472b.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 03 15" src="https://user-images.githubusercontent.com/24765473/182519414-e9cf6129-8aa8-4b77-a042-db5827a993bd.png">

<img width="1366" alt="Screen Shot 2022-08-02 at 21 03 36" src="https://user-images.githubusercontent.com/24765473/182519423-5551577b-e07f-4052-9d9c-08bc5fe42bb4.png">

<img width="1361" alt="Screen Shot 2022-08-02 at 21 04 02" src="https://user-images.githubusercontent.com/24765473/182519433-7963aa7b-888d-4846-816e-070408971cf0.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 04 14" src="https://user-images.githubusercontent.com/24765473/182519446-92ea1739-6850-4e82-9cc3-cff46e679bc1.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 05 05" src="https://user-images.githubusercontent.com/24765473/182519460-8148164f-4bc1-4154-a461-081729a6f447.png">

<img width="1368" alt="Screen Shot 2022-08-02 at 21 05 32" src="https://user-images.githubusercontent.com/24765473/182519471-e10dbe61-b53d-4a30-99ae-c50f70de0eff.png">

<img width="1366" alt="Screen Shot 2022-08-02 at 21 05 54" src="https://user-images.githubusercontent.com/24765473/182519483-22bb923f-7dd9-4642-915c-0a20a54966cf.png">

<img width="1367" alt="Screen Shot 2022-08-02 at 21 06 09" src="https://user-images.githubusercontent.com/24765473/182519495-a5b39230-19e2-4767-8a2c-90bc383d19e4.png">

<img width="1366" alt="Screen Shot 2022-08-02 at 21 06 20" src="https://user-images.githubusercontent.com/24765473/182519515-89af89fe-dc4e-41de-85d7-a5db4fac5b7b.png">

<img width="1367" alt="Screen Shot 2022-08-02 at 21 06 44" src="https://user-images.githubusercontent.com/24765473/182519525-87bf149a-e272-4604-8190-f0d0712763db.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 07 55" src="https://user-images.githubusercontent.com/24765473/182519543-51a4d6a1-6a32-48f0-b42e-9e4fb84ebc03.png">

<img width="1364" alt="Screen Shot 2022-08-02 at 21 08 08" src="https://user-images.githubusercontent.com/24765473/182519561-57f5b810-a382-44ae-ab32-c24f5ac113d4.png">

### 3b1 - domain validation via TXT record

30 seconds for DNS propagation then the diaglog should continue.
<img width="1370" alt="Screen Shot 2022-08-02 at 21 08 37" src="https://user-images.githubusercontent.com/24765473/182519576-7910d045-8ef4-4e45-a654-61eeb8543daf.png">

<img width="1363" alt="Screen Shot 2022-08-02 at 21 09 13" src="https://user-images.githubusercontent.com/24765473/182519591-01afcf4a-5307-4760-a7f0-4619c28fd587.png">

<img width="1357" alt="Screen Shot 2022-08-02 at 21 09 35" src="https://user-images.githubusercontent.com/24765473/182519601-7b37c50f-a202-47ee-8a6c-fbef363d2688.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 09 55" src="https://user-images.githubusercontent.com/24765473/182519608-4793db52-b573-4acb-9100-bb39fcca435f.png">

<img width="1193" alt="Screen Shot 2022-08-02 at 21 11 22" src="https://user-images.githubusercontent.com/24765473/182519622-8269310c-ecfa-49fc-b91d-9c2c3f558124.png">

<img width="1709" alt="Screen Shot 2022-08-02 at 21 11 46" src="https://user-images.githubusercontent.com/24765473/182519629-cd38f30b-070d-406a-8098-4c2155b6e658.png">

<img width="1704" alt="Screen Shot 2022-08-02 at 21 12 07" src="https://user-images.githubusercontent.com/24765473/182519635-fe877497-9250-4f0d-b67f-80db02dc0eb7.png">

<img width="1097" alt="Screen Shot 2022-08-02 at 21 12 33" src="https://user-images.githubusercontent.com/24765473/182519668-306f8d30-ccbc-432f-85cc-7f04c19feb42.png">

<img width="1359" alt="Screen Shot 2022-08-02 at 21 13 41" src="https://user-images.githubusercontent.com/24765473/182519682-d97a192b-fe7a-4775-998c-7df88fc8b75c.png">

<img width="1059" alt="Screen Shot 2022-08-02 at 21 13 48" src="https://user-images.githubusercontent.com/24765473/182519695-6b3cff90-7237-4063-add2-da1a31ed4765.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 14 12" src="https://user-images.githubusercontent.com/24765473/182519714-64a4fd1f-b2c0-476d-bb0e-5cb03a5ed80e.png">

<img width="529" alt="Screen Shot 2022-08-02 at 21 14 27" src="https://user-images.githubusercontent.com/24765473/182519730-d6ad4f9d-5337-4800-8a42-d3fb8493568d.png">

<img width="1368" alt="Screen Shot 2022-08-02 at 21 14 38" src="https://user-images.githubusercontent.com/24765473/182519750-5cc304b3-c7c8-45e0-b796-ff3a3b7dbcbe.png">

<img width="1369" alt="Screen Shot 2022-08-02 at 21 15 05" src="https://user-images.githubusercontent.com/24765473/182519767-d8529006-09de-47ac-a0ce-cea04d32bc3b.png">

<img width="843" alt="Screen Shot 2022-08-02 at 21 15 46" src="https://user-images.githubusercontent.com/24765473/182519780-95ac39bc-ba00-4a1e-ba8f-a8c5737b3522.png">

<img width="1365" alt="Screen Shot 2022-08-02 at 21 16 44" src="https://user-images.githubusercontent.com/24765473/182519787-b74dabad-780c-4808-b9c4-c6671e5d7514.png">

### Adding target user as Billing Administrator on shared billing account
<img width="1365" alt="Screen Shot 2022-08-03 at 08 27 26" src="https://user-images.githubusercontent.com/24765473/182612579-ed971684-4922-4b9c-a466-cd7026446a42.png">

<img width="1367" alt="Screen Shot 2022-08-03 at 08 28 10" src="https://user-images.githubusercontent.com/24765473/182612722-910abf58-97e3-456d-b1bf-492a4f428de3.png">

<img width="1369" alt="Screen Shot 2022-08-03 at 08 28 31" src="https://user-images.githubusercontent.com/24765473/182612749-68331275-73d5-42f0-9722-37d08728bc27.png">

<img width="1363" alt="Screen Shot 2022-08-03 at 08 30 15" src="https://user-images.githubusercontent.com/24765473/182612777-088bc17c-87b6-407c-a9d2-9a091e6f13e3.png">

<img width="1364" alt="Screen Shot 2022-08-03 at 08 30 30" src="https://user-images.githubusercontent.com/24765473/182612798-0fdf1d41-8d19-4979-a77e-a91fc2422eb7.png">

<img width="1362" alt="Screen Shot 2022-08-03 at 08 30 57" src="https://user-images.githubusercontent.com/24765473/182612860-bb883d6b-6a53-4a47-823a-e56505dadcbe.png">

<img width="1367" alt="Screen Shot 2022-08-03 at 08 31 23" src="https://user-images.githubusercontent.com/24765473/182612892-03cf13f4-e91c-41e7-9a5e-1aa3fec53c9b.png">

<img width="1367" alt="Screen Shot 2022-08-03 at 08 32 34" src="https://user-images.githubusercontent.com/24765473/182612918-8957c29b-783f-4b4c-8f65-783519f2b43c.png">

### Try direct linking in IAM

- Note: the billing adminstrator role must be added to the target cloud identity account by the owner of the billing id - this is done in the "manage billing" section of billing - separate from adding the role in IAM.
- 
<img width="1362" alt="Screen Shot 2022-08-03 at 08 33 29" src="https://user-images.githubusercontent.com/24765473/182613045-10f45858-10bb-468d-af19-b51188c01648.png">

<img width="1357" alt="Screen Shot 2022-08-03 at 08 33 50" src="https://user-images.githubusercontent.com/24765473/182613091-4dc0c426-ee26-43a7-9f3c-bf0d1017389c.png">

<img width="1362" alt="Screen Shot 2022-08-03 at 08 34 21" src="https://user-images.githubusercontent.com/24765473/182613130-daa26121-55e7-48e7-acfd-f5aeef1d9fb9.png">

<img width="1011" alt="Screen Shot 2022-08-03 at 08 35 35" src="https://user-images.githubusercontent.com/24765473/182613193-eb5b5aa4-4101-41bc-b89f-baf90760f24e.png">

<img width="1015" alt="Screen Shot 2022-08-03 at 08 35 55" src="https://user-images.githubusercontent.com/24765473/182613245-a714deb9-876e-430a-b19d-6071078102fa.png">

<img width="1361" alt="Screen Shot 2022-08-03 at 08 36 20" src="https://user-images.githubusercontent.com/24765473/182613263-829c6804-65b1-4d94-9f9d-f917cfaed7c8.png">

<img width="1363" alt="Screen Shot 2022-08-03 at 08 36 48" src="https://user-images.githubusercontent.com/24765473/182613287-360a4fd5-b9a9-4cbe-bb52-d031de97d834.png">

<img width="1366" alt="Screen Shot 2022-08-03 at 08 37 35" src="https://user-images.githubusercontent.com/24765473/182613310-afbf7e74-9446-488c-bb84-47da47ee65c9.png">

### We see the no organization issue - no problem we can still use the account for the main organization

<img width="1366" alt="Screen Shot 2022-08-03 at 08 38 33" src="https://user-images.githubusercontent.com/24765473/182613334-55ac3af3-ad48-40f0-885d-dd337e572ba8.png">

<img width="1365" alt="Screen Shot 2022-08-03 at 08 39 13" src="https://user-images.githubusercontent.com/24765473/182613607-c2f378d3-bfe3-472a-8e65-d31623ca5fea.png">

<img width="1356" alt="Screen Shot 2022-08-03 at 08 39 27" src="https://user-images.githubusercontent.com/24765473/182613700-caa4a54a-d89c-4792-ba50-fcb1ac089e72.png">

<img width="1368" alt="Screen Shot 2022-08-03 at 08 40 20" src="https://user-images.githubusercontent.com/24765473/182613744-b843eb07-d24b-4e12-86f5-8b73efdda82e.png">

### Linking an external billing id - post creation

<img width="976" alt="Screen Shot 2022-08-02 at 11 56 22 PM" src="https://user-images.githubusercontent.com/94715080/182521280-342da5a9-cd5f-4b96-9fd7-6f6fe248d5c2.png">

<img width="1058" alt="Screen Shot 2022-08-02 at 11 56 53 PM" src="https://user-images.githubusercontent.com/94715080/182521293-43561208-650c-4b31-b146-c7a8285ed347.png">

<img width="1177" alt="Screen Shot 2022-08-02 at 11 57 06 PM" src="https://user-images.githubusercontent.com/94715080/182521301-3e52cfef-e303-4294-aa65-37252299fb04.png">

<img width="1156" alt="Screen Shot 2022-08-02 at 11 57 18 PM" src="https://user-images.githubusercontent.com/94715080/182521310-8aa006d0-91c1-4684-ac9d-980373ca344e.png">

## Onboarding Category 5: 3rd party Email - 3rd party Domain

This category is common for organizations new to GCP or multicloud where both the email system and DNS hosting zone are 3rd party

See the similar section [Onboarding Catagory 3 - GCP hosted domains](#onboarding-category-3-gmail-account---domain-hosted-on-google-domains)

### Category 5a: First 3rd party Email - 3rd party Domain requires TXT verification

### Category 5b: First 3rd party Email - 3rd party Domain requires indirect verification
Usually copy/paste or email


### Category 5c: second 3rd party Email - 3rd party Domain already verified
- using the original super admin/owner create another cloud identity account with an email on the organization domain - with optional email forward to their work email.  Give rights such as "Owner" or "Folder Admin" to this 2nd+ user, when they login to console.cloud.google.com they will already have proper access to the organization (no domain validation required)

goto the admin page at admin.google.com

<img width="784" alt="5c-1" src="https://user-images.githubusercontent.com/94715080/169107772-9eb92ccd-0c3e-41ee-8844-77fc01a4fdc9.png">

Add the new user - using an existing super admin user

<img width="1202" alt="5c-2" src="https://user-images.githubusercontent.com/94715080/169107798-4a3ab66a-9f24-4ab6-9bd2-1f98044b9a49.png">

send login instructions - with temp password

<img width="949" alt="5c-3" src="https://user-images.githubusercontent.com/94715080/169107829-3b2a1ada-628e-435b-b563-6b315d5f9f1f.png">

Start witn an incognito chrome window

<img width="1527" alt="5c-4" src="https://user-images.githubusercontent.com/94715080/169107861-f9076e19-5eff-4a6d-a29c-c725247fd522.png">

launch accounts.google.com

<img width="665" alt="5c-5" src="https://user-images.githubusercontent.com/94715080/169107897-7c496cb1-1085-4f59-b6ec-6d78176ef424.png">

Login to new user

<img width="1017" alt="5c-6" src="https://user-images.githubusercontent.com/94715080/169107928-16cedc7e-f76a-4c4a-a391-ebe781968afc.png">

new account splash

<img width="1125" alt="5c-7" src="https://user-images.githubusercontent.com/94715080/169107958-ebe88b07-d840-4418-91cb-8d0512e8fe7b.png">

auto change password

<img width="965" alt="5c-8" src="https://user-images.githubusercontent.com/94715080/169107973-6f02ab4c-f117-473f-81aa-f27a915a67a1.png">

view new account

<img width="1192" alt="5c-9" src="https://user-images.githubusercontent.com/94715080/169107999-66ccf18f-9906-433b-affa-afbba278fce4.png">

select profile picture on top right - add (to get a new chrome profile for the user)

<img width="1021" alt="5c-10" src="https://user-images.githubusercontent.com/94715080/169108035-a0948886-bc09-4a05-8e9c-6b6046ea28c0.png">

login again

<img width="1019" alt="5c-11a" src="https://user-images.githubusercontent.com/94715080/169108055-305a9ca7-7bf1-451a-8514-152fee4a8c41.png">

accept profile

<img width="1020" alt="5c-12a" src="https://user-images.githubusercontent.com/94715080/169108108-604b1725-2fe4-4cd9-900c-42e60c9423bd.png">

Navigate to the cloud at console.cloud.google.com

<img width="482" alt="5c-13a" src="https://user-images.githubusercontent.com/94715080/169108142-aaeeba2a-0711-4d13-ac25-1f85b08b6d4c.png">

Accept the license

<img width="1524" alt="5c-14a" src="https://user-images.githubusercontent.com/94715080/169108167-e98a0de6-83eb-43b4-a4d1-e5de3e87ca5c.png">

View that you are already on the existing organization (no DNS verify required)

<img width="1515" alt="5c-15a" src="https://user-images.githubusercontent.com/94715080/169108221-b134e86f-76cf-4162-86cf-5314693c447e.png">

Attempt to create a project - switch to the org

<img width="1125" alt="5c-16a" src="https://user-images.githubusercontent.com/94715080/169108265-73b57e4a-ccea-4ae1-ba4b-f196a46c7532.png">

select the organization - normal without a higher role we will set with the super admin user

<img width="1127" alt="5c-17a" src="https://user-images.githubusercontent.com/94715080/169108292-46170222-9dfe-4320-8900-7d9c16c7a3a6.png">

verify you don't have rights yet to the organization

<img width="1525" alt="5c-18a" src="https://user-images.githubusercontent.com/94715080/169108322-2ee8977c-73d4-4b24-8b62-fabb8d16fa70.png">

check the onboarding checklist to verify

<img width="1010" alt="5c-20a" src="https://user-images.githubusercontent.com/94715080/169108347-50a0ae6a-7a49-413b-95b0-cd46a0c85acd.png">

Yes, you don't have the rights yet

<img width="1523" alt="5c-21a" src="https://user-images.githubusercontent.com/94715080/169108372-a99d6ac3-421a-4dfc-895c-f46575e4f9ff.png">

Switch tabs to the other super admin user - goto IAM to verify roles

<img width="1429" alt="5c-23b" src="https://user-images.githubusercontent.com/94715080/169108396-751a6040-ab1c-4131-b528-221dc6cf25c6.png">

Add the new user to the role of "Owner" for now - normally use "Folder creator" and "Organization Administrator" for example

<img width="1221" alt="5c-24b" src="https://user-images.githubusercontent.com/94715080/169108424-d0c17e1f-b5ba-4dac-b941-f3bb7b55fdce.png">

Verify the user 2 role change

<img width="1396" alt="5c-25b" src="https://user-images.githubusercontent.com/94715080/169108468-1884ddec-a359-4b4a-a896-225e44fbe13a.png">

back at user 2 navigate to IAM | cloud identity | verify your new rights

<img width="1113" alt="5c-26a" src="https://user-images.githubusercontent.com/94715080/169108486-fda6cce7-b395-4f7e-8915-7b1e9a61616c.png">

Notice you now have rights to the organization - good to go

<img width="1125" alt="5c-27a" src="https://user-images.githubusercontent.com/94715080/169108503-a119bfb6-ec46-49c8-bd29-d1fdd873704c.png">






## Onboarding Category 6: Gmail Email - 3rd party Domain

This category is a variant of category 3 where there is a gmail account with option redirect where the organization zone records are on a 3rd party DNS system

## Onboarding Category 8: 3rd party Email - no Domain

This category is common for individual consumers where they do not have a gmail account or any domain.  This option will not have an organization top node in IAM

## Onboarding Category 9: Gmail  Email - no Domain

This category is common for individual consumers where they gmail account but no domain.  This option will not have an organization top node in IAM

# Onboarding to Google Cloud using a cloud identity account
## Google Cloud Identity

Google Cloud Identity accounts are ideal for cloud account organizations where the user identities are maintained outside of Google cloud in for example AWS Workmail or Azure Active Directory.

## Planning

Create or gain access to the domain you wish to associate or federate users from.  For example packet.global.

You will need access to the domain zone to add TXT records for domain validation under a subdomain like gcp.packet.global

Open Chrome Window with no Google Account

## Onboarding to Google Cloud using a cloud identity account and a 3rd party managed domain - AWS Route53

## Onboarding to Google Cloud using a cloud identity account and a Google managed domain
.. continuing from "open chrome window" above


Launch SignUpWithoutGmail - select gmail

https://accounts.google.com/SignUpWithoutGmail

Select gmail, register and launch a new browser - add new account - login

Create your Google Account (gmail)

<img width="1197" alt="_eventstream_1" src="https://user-images.githubusercontent.com/94715080/169108568-45b3b0d4-d6a2-49fb-8a3f-3daf27cd14fa.png">


launch google cloud

https://console.cloud.google.com/

do not select an org yet - as the domain under GCP registration does not have an email yet and is not registered with workspace.

You will not be able to run the organization checklist account as a gmail user - https://console.cloud.google.com/cloud-setup/organization

Add Cloud Identity free in

https://cloud.google.com/identity/docs/set-up-cloud-identity-admin

follow

https://workspace.google.com/signup/gcpidentity/welcome#0

add your gmail address and GCP domain

Add email capability https://support.google.com/cloudidentity/answer/7667994

Select the email left tab on
https://domains.google.com/registrar/eventstream.dev/email?hl=en-US

Select email forwarding to to your gmail account

Launch gmail to verify email - don't worry it will launch domains in your current gmail account - verify that the verify worked in your other account that holds the domain registration

image

Check email forwarding on the DNS tab

image

wait for DNS record propagation 30 sec and recheck the cloud identity wizard warning on no email MX records

image

continue wizard regardless of warning - use your new email forward address

https://workspace.google.com/signup/gcpidentity/tos

goto setup after creation

image

Launch admin

Since I have used this phone a couple times - get past the unusual activity dialog

Identity account OK

select getting started

https://admin.google.com/u/1/ac/signup/setup/v2/gettingstarted

Verify domain - sign in option will not work on this browser - as I have it registered on another account - in this case select "Switch Verification Method" and select the 2nd TXT option.


add the TXT record

Click Verify back on the admin page

The org in this case will automatically create when you click the link below (no subdomain as the TXT record is the first on the domain.  If there is already a root domain TXT record - you will need to use a subdomain like gcp.domain.com

org is setup as the TXT record is against the root domain on the separate GCP account

# Onboarding to Google Cloud using a workspace account

## Onboarding to Google Cloud using a workspace account and a Google managed domain

# Onboarding to Google Cloud using a gmail account

https://accounts.google.com/SignUpWithoutGmail

Fill in the form with an existing email address outside of Google





Launch from step 2 of the IAM | Cloud Identity & Organization | checklist https://console.cloud.google.com/cloud-setup/organization

to https://workspace.google.com/signup/gcpidentity/welcome

# Onboarding to Google Cloud using a 3rd party email account



# Onboarding Accounts and Projects Structure

Following is an example manually created landing zone infrastructure - however continue to use this landing zone for production environments.

1 - as original root super admin user

1a - create root organization on cloud login - done above

admin-root permissions
```
Folder Admin
Organization Administrator
Owner
```

1b - create user acc-1 in admin.google.com

navigate to http://admin.google.com

<img width="1569" alt="Screen Shot 2022-06-05 at 16 13 46" src="https://user-images.githubusercontent.com/24765473/172070965-eb4cb9c9-c944-4fe2-a13f-587aaa4ad5fd.png">

<img width="1571" alt="Screen Shot 2022-06-05 at 16 14 05" src="https://user-images.githubusercontent.com/24765473/172070970-26b8d605-16a2-4b0b-80be-502e0ebc98ca.png">

Dont worry about saving the password - we wil reset it
<img width="1578" alt="Screen Shot 2022-06-05 at 16 14 23" src="https://user-images.githubusercontent.com/24765473/172070974-e102ee63-307b-4d8b-b18a-d2a7f257a9fb.png">

<img width="1574" alt="Screen Shot 2022-06-05 at 16 14 42" src="https://user-images.githubusercontent.com/24765473/172070988-2eeece21-01f8-4667-99f3-1bdac84fe2fb.png">

<img width="1574" alt="Screen Shot 2022-06-05 at 16 15 04" src="https://user-images.githubusercontent.com/24765473/172070991-7b312d6c-92a2-45fe-80f9-bccdd0daf244.png">

1c - add acc-1 user to super admins

<img width="1572" alt="Screen Shot 2022-06-05 at 16 15 41" src="https://user-images.githubusercontent.com/24765473/172071001-fd4e9cfd-01b3-4dc0-ae1e-8183ce14e5d2.png">

<img width="1580" alt="Screen Shot 2022-06-05 at 16 15 59" src="https://user-images.githubusercontent.com/24765473/172071008-2694c896-3985-462d-8538-ed82f6b19357.png">

<img width="1572" alt="Screen Shot 2022-06-05 at 16 16 09" src="https://user-images.githubusercontent.com/24765473/172071018-4566937f-942f-481f-9fdf-0072f6828d4b.png">

1d - add acc-1 user IAM roles

navigate to http://console.cloud.google.com - search on IAM and switch the project dropdown to the organization

```
Billing Account Administrator
Folder Admin
Organization Administrator
Organization Policy Administrator
```

<img width="1558" alt="Screen Shot 2022-06-05 at 17 20 33" src="https://user-images.githubusercontent.com/24765473/172071097-d6a870dc-2487-4423-91a8-078091065412.png">

<img width="1572" alt="Screen Shot 2022-06-05 at 17 20 45" src="https://user-images.githubusercontent.com/24765473/172071110-3854f402-ed7e-4987-bc30-28fc2fef9222.png">

Click add - and start typing acc in the principle or past the entire email of the acc user

Add Billing Account Administrator, Folder Admin, Organization Administrator, Organization Policy Administrator and hold off on Owner and Folder Admin.

<img width="1568" alt="Screen Shot 2022-06-05 at 17 26 57" src="https://user-images.githubusercontent.com/24765473/172071407-d8e975ca-e484-45b5-afae-37c528f3a0ef.png">

<img width="1571" alt="Screen Shot 2022-06-05 at 17 30 32" src="https://user-images.githubusercontent.com/24765473/172071481-3950647a-679b-493b-881a-6a5531c83241.png">

1e - add extra billing accounts - or do in step 2d

2 - as acc-1 user

Create a new Chrome profile and login as acc-1@domain

<img width="1018" alt="Screen Shot 2022-06-05 at 17 32 41" src="https://user-images.githubusercontent.com/24765473/172071596-feee235a-78dd-47e9-a73c-8096c9ad2545.png">

<img width="1015" alt="Screen Shot 2022-06-05 at 17 33 01" src="https://user-images.githubusercontent.com/24765473/172071610-a561ee3c-7078-428d-8174-d4b7987fee96.png">

<img width="1020" alt="Screen Shot 2022-06-05 at 17 33 10" src="https://user-images.githubusercontent.com/24765473/172071616-3dbbee29-83c2-4bf6-9569-800339fa290a.png">


2a - create business folder at root

Open http://console.cloud.google.com

<img width="1573" alt="Screen Shot 2022-06-05 at 17 36 07" src="https://user-images.githubusercontent.com/24765473/172071636-69a25323-3356-4f4f-8c6d-01749d31c600.png">

Switch to the organization in IAM

<img width="1567" alt="Screen Shot 2022-06-05 at 17 36 47" src="https://user-images.githubusercontent.com/24765473/172071652-3eac7740-f400-459d-8cd5-c9b82f85ad7a.png">

Goto resouce manager off IAM

<img width="1575" alt="Screen Shot 2022-06-05 at 17 37 47" src="https://user-images.githubusercontent.com/24765473/172071677-4f29b143-612e-41a8-96a6-d9ac6693703c.png">

<img width="1570" alt="Screen Shot 2022-06-05 at 17 38 30" src="https://user-images.githubusercontent.com/24765473/172071752-021a5d36-865c-42b8-9f67-a0d7a3f99a08.png">

<img width="1570" alt="Screen Shot 2022-06-05 at 17 38 54" src="https://user-images.githubusercontent.com/24765473/172071753-5aa55370-ea4c-4d63-869a-71d5942ab357.png">

2b - create project business-unit off business folder

You will need to search on the new folder

<img width="1284" alt="Screen Shot 2022-06-05 at 17 39 13" src="https://user-images.githubusercontent.com/24765473/172071757-134b7def-6282-49cd-9a45-df961134bf9c.png">

Note: projects must be globally unique - append the first chars of your domain name to differentiate - here nuage-cloud = nc

<img width="1576" alt="Screen Shot 2022-06-05 at 17 39 54" src="https://user-images.githubusercontent.com/24765473/172071763-453abc1d-ea50-43c6-bd1d-1aa41e70dcd6.png">

2c - create users bus-1 and dev-1 in admin

Login to http://admin.google.com

<img width="1575" alt="Screen Shot 2022-06-05 at 17 33 36" src="https://user-images.githubusercontent.com/24765473/172071621-f3502ba9-6e4a-4459-81af-aaec9bbc0bfb.png">

<img width="1567" alt="Screen Shot 2022-06-05 at 17 43 18" src="https://user-images.githubusercontent.com/24765473/172071859-0e90b1fd-6703-424b-8ff0-90a848fd0c2f.png">

<img width="1569" alt="Screen Shot 2022-06-05 at 17 42 19" src="https://user-images.githubusercontent.com/24765473/172071852-cb0d297e-7f87-4fdd-942c-621610124213.png">

<img width="1573" alt="Screen Shot 2022-06-05 at 17 44 15" src="https://user-images.githubusercontent.com/24765473/172071873-23dae502-813a-4153-8e98-f8b9bef630f4.png">

Reset passwords

2d - add bus-1 and dev-1 IAM roles

Login as acc-1 user in http://cloud.google.com

bus-1 has (BigQuery Admin, Billing Account Administrator, Compute Admin, Compute Network Admin, Folder Admin, Logging Admin, Monitoring Admin, Networks Admin, Project Billing Manager, PubSub Admin Security Admin, Storage Admin, Tag Administrator)

```
Billing Account Administrator
Folder Admin
Logging Admin
Monitoring Admin
Networks Admin
Project Billing Manager
Security Admin
Storage Admin
Tag Administrator
```
<img width="1575" alt="Screen Shot 2022-06-05 at 17 53 50" src="https://user-images.githubusercontent.com/24765473/172072222-62da778f-f981-4531-a4b7-89320e4e9f10.png">

dev-n has to start (BigQuery Admin, CloudSQL Admin, Compute Admin, Compute Network Admin, Networks Admin, Network Management Admin, PubSub Admin, Storage Admin)

```
BigQuery Admin
Cloud SQL Admin
Compute Admin
Compute Network Admin
Logging Admin
Monitoring Admin
Network Management Admin
Pub/Sub Admin
Source Repository Administrator
Source Repository Writer
Storage Admin
Viewer
```

For multiple accounts - use a group email in Admin and target the group account in IAM or use a custom IAM role composed of individual roles

Create group in admin for developers - add bus-1 as the owner add dev-1/2 as members
<img width="1570" alt="Screen Shot 2022-06-05 at 17 56 25" src="https://user-images.githubusercontent.com/24765473/172072347-36b908da-9e8c-4e79-9d3d-750b6d57325e.png">

<img width="1573" alt="Screen Shot 2022-06-05 at 17 57 15" src="https://user-images.githubusercontent.com/24765473/172072349-03a0cebe-10e3-40f2-b30d-082b7556c3eb.png">

<img width="1572" alt="Screen Shot 2022-06-05 at 17 57 26" src="https://user-images.githubusercontent.com/24765473/172072352-6ce9ca70-fdb5-4a01-a1f3-cfe29fd79aa6.png">

<img width="1569" alt="Screen Shot 2022-06-05 at 17 57 39" src="https://user-images.githubusercontent.com/24765473/172072359-198a3e68-b2e8-4ff0-a262-0ff770d56c5d.png">

<img width="1564" alt="Screen Shot 2022-06-05 at 17 57 57" src="https://user-images.githubusercontent.com/24765473/172072365-5bb2fc83-a8b5-48a1-bf50-a0a06771a724.png">

Add the above roles for dev-1/2 to developers@domain in IAM

<img width="1577" alt="Screen Shot 2022-06-05 at 18 03 22" src="https://user-images.githubusercontent.com/24765473/172072489-4111c1af-9e26-4d28-aa94-d67eedff0015.png">

3 - as bus-1 user

Create Chrome Profile and login to http://cloud.google.com

<img width="1016" alt="Screen Shot 2022-06-05 at 18 05 27" src="https://user-images.githubusercontent.com/24765473/172072599-31c7d568-e3b4-48f6-8db7-0a945aaf6153.png">

<img width="1629" alt="Screen Shot 2022-06-05 at 18 06 11" src="https://user-images.githubusercontent.com/24765473/172072610-a1222671-3469-4af1-b49d-93c6ab8ba3e5.png">

Switch to the org

<img width="1630" alt="Screen Shot 2022-06-05 at 18 06 29" src="https://user-images.githubusercontent.com/24765473/172072614-89b06d3e-b635-4cfa-87bb-c505eb803e96.png">

Add Project Billing Manager role if missed above to IAM permissions

3a - create folders sandbox and project off business folder

3b - create project deployment-1 off project folder

3c - create project pipeline-1 off project folder

3d - create project sandbox-1 and 2 off sandbox folder

3e - associate billing account 2 and 3 with sandbox 1 and 2


<img width="1636" alt="Screen Shot 2022-06-05 at 18 20 37" src="https://user-images.githubusercontent.com/24765473/172073620-47bed8d7-e0a6-49a2-866b-285319c8fd71.png">

<img width="1630" alt="Screen Shot 2022-06-05 at 18 21 48" src="https://user-images.githubusercontent.com/24765473/172073621-795e6c06-67a9-4eeb-b301-d6c4ef49565c.png">

<img width="1636" alt="Screen Shot 2022-06-05 at 18 22 48" src="https://user-images.githubusercontent.com/24765473/172073626-c0b4af19-e74e-497b-9542-c4c52aa29c83.png">

<img width="1641" alt="Screen Shot 2022-06-05 at 18 23 35" src="https://user-images.githubusercontent.com/24765473/172073628-0683f633-ba09-4cfe-84a4-3717c364a40e.png">

<img width="1636" alt="Screen Shot 2022-06-05 at 18 25 07" src="https://user-images.githubusercontent.com/24765473/172073633-07d1c595-89c7-4444-8374-e154f0a8cfc0.png">

<img width="1636" alt="Screen Shot 2022-06-05 at 18 26 15" src="https://user-images.githubusercontent.com/24765473/172073651-9887ed18-e3d0-4961-b844-814be3d8d06d.png">


Create 3rd billing account before associating sandbox-2 if different billing accounts needed.  Note: if you change the contact email away from the default a decision may take 48h 
<img width="1637" alt="Screen Shot 2022-06-05 at 18 28 49" src="https://user-images.githubusercontent.com/24765473/172073606-4b8c1b68-1653-4d45-9339-619eee3767d8.png">

<img width="1646" alt="Screen Shot 2022-06-05 at 18 30 26" src="https://user-images.githubusercontent.com/24765473/172073608-bf3c5ff2-52df-46e7-b9ae-abff594456fd.png">

<img width="256" alt="Screen Shot 2022-06-05 at 18 37 16" src="https://user-images.githubusercontent.com/24765473/172073612-a9b3c36a-5744-43b8-a69d-99ad1cb5b402.png">

4 - as dev-1 user
Even though i reset the password of this user - the new Chrome profile forced me to change it this time.  The dev user also shows up with the credit dialog
<img width="1018" alt="Screen Shot 2022-06-05 at 18 54 36" src="https://user-images.githubusercontent.com/24765473/172074305-349bab04-d52d-44bb-b678-b800fc73558a.png">

<img width="1014" alt="Screen Shot 2022-06-05 at 18 55 04" src="https://user-images.githubusercontent.com/24765473/172074307-a5632143-07a9-4867-aefb-4eb1dc628566.png">

<img width="1014" alt="Screen Shot 2022-06-05 at 18 55 04" src="https://user-images.githubusercontent.com/24765473/172074311-0d694167-0564-404d-932a-8a081e562820.png">

<img width="1632" alt="Screen Shot 2022-06-05 at 18 58 49" src="https://user-images.githubusercontent.com/24765473/172074316-6b8fefb1-c3b1-41b1-8f12-ab0ed3040c5b.png">

Select the org in IAM - verify restricted permissions
<img width="1631" alt="Screen Shot 2022-06-05 at 18 59 17" src="https://user-images.githubusercontent.com/24765473/172074319-3a0b781b-0d62-4cc7-aac6-4177638cc586.png">

<img width="1639" alt="Screen Shot 2022-06-05 at 19 01 45" src="https://user-images.githubusercontent.com/24765473/172074294-471eccb0-c51d-4430-b93a-9316aaaed744.png">

Select the project you have access to in IAM - verify IAM is ok

Add project viewer if not already applied

<img width="1577" alt="Screen Shot 2022-06-05 at 19 03 37" src="https://user-images.githubusercontent.com/24765473/172074281-dabedfe8-93a9-4270-84f5-4e314da65503.png">

<img width="573" alt="Screen Shot 2022-06-05 at 19 04 01" src="https://user-images.githubusercontent.com/24765473/172074282-a5aedf69-1259-4f7e-8c36-c56188189cf8.png">

<img width="1629" alt="Screen Shot 2022-06-05 at 19 05 00" src="https://user-images.githubusercontent.com/24765473/172074284-24712c51-ed19-4578-8950-68b71fc28c66.png">

4a - create specific infrastructure in sandbox-1 project

Verify no access to projects outside your scope
<img width="763" alt="Screen Shot 2022-06-05 at 19 09 21" src="https://user-images.githubusercontent.com/24765473/172074395-99d28c32-8460-447f-b26d-9dffd8c312d7.png">

Add source.repos.create permissions in bus-1
<img width="1547" alt="Screen Shot 2022-06-05 at 19 11 15" src="https://user-images.githubusercontent.com/24765473/172074449-d8ca6a1b-84df-4252-9181-e237e484f042.png">

Add source repository admin - to be able to create new CSR repos
<img width="1643" alt="Screen Shot 2022-06-05 at 19 17 07" src="https://user-images.githubusercontent.com/24765473/172074656-adc09168-0cff-4914-a415-a3d7c80917f9.png">

verify Permissions on the sandbox project for the developers group in bus-1

<img width="1253" alt="Screen Shot 2022-06-05 at 19 19 16" src="https://user-images.githubusercontent.com/24765473/172074713-49f7a54a-1d94-42de-8613-479d8c331b65.png">

<img width="1636" alt="Screen Shot 2022-06-05 at 19 20 11" src="https://user-images.githubusercontent.com/24765473/172074750-2ad2c344-251c-4f0e-bef7-6affdc91e48f.png">

Verify access to projects inside your scope

Create the CSR

<img width="1629" alt="Screen Shot 2022-06-05 at 19 20 43" src="https://user-images.githubusercontent.com/24765473/172074762-cf4c0b9a-334a-4619-96b6-e7fbbfa8237f.png">

<img width="1633" alt="Screen Shot 2022-06-05 at 19 21 30" src="https://user-images.githubusercontent.com/24765473/172074772-7660c720-510d-4aef-9994-561fec05f99b.png">

Verify billing in bus-1 is set to a different account for the sandbox-1 project

<img width="937" alt="Screen Shot 2022-06-05 at 19 22 24" src="https://user-images.githubusercontent.com/24765473/172074805-00498196-2ae6-4246-bd37-30735856e4a3.png">


4b - use specific intrastructure in deployment-1 and pipeline-1 project 

5 - as dev-2 user

5a - create a cloud run deployment from an existing container in deployment -1

# Category 10: Workaround for DENY flagged domain during Cloud Identity creation

During testing for the following section https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-3b1-3rd-party-email-account---3rd-party-aws-route53-domain-validation---reuse-existing-billing-account

On occasion you will get the following DENY https://workspace.google.com/signup/gcpidentity/deny on creating a cloud identity user during organization onboarding using the procedure in https://cloud.google.com/identity/docs/set-up-cloud-identity-admin if you repeatedly use the same cloud identity creation process for the same domain

<img width="1363" alt="Screen Shot 2022-08-02 at 20 54 20" src="https://user-images.githubusercontent.com/24765473/183114616-b75a44fa-a269-448f-a6fe-f83caf9f52c0.png">

using for example a couple attempts on 

<img width="1368" alt="Screen Shot 2022-08-02 at 20 52 03" src="https://user-images.githubusercontent.com/24765473/183114714-46bc5280-825e-4c6c-8248-2c30e5a8ca29.png">


The primary workaround is to contact your FSR or CE and/or support to get your domain on an allowlist.  The SLO for this is usually under 24 hours.

The secondary workaround is to use a separate TLD domain and subdomain for now.  The full workaround is TBD (time based, Google Support unflag...TBD).
The fact that the dialog states that your computer may be compromised is very likely not the issue as I have registered another cloud identity account right after on the same machine/browser.  The issue looks to be domain related on domains new to google cloud that have had several attempts at creating a cloud identity account on the same domain.

I retested this particular domain for timing and using a different email, subdomain and also look for a workaround and/or support fix - will try different computer/5G location for the flagged domain.

After the domain allowlist entry - Cloud Identity onboarding proceeded OK.

https://workspace.google.com/signup/gcpidentity/done

<img width="1767" alt="Screen Shot 2022-08-11 at 14 55 21" src="https://user-images.githubusercontent.com/94715080/184220009-124cdc0b-cd97-49e8-a9a9-61151e344097.png">


# Category 11: Onboarding without access to the domain zone - variant use case
- 20220809: TBD - document any procedure to create an organization without access to the actual domain - where TXT record submission to the zone is not possible.  I would expectd that this is variant use case and could be used to add subdomain to a domain the client does not own - hence private zone access only in this case.  However there are cases where the user has not yet gained access to the domain zone in their org and wishes to create/validate the domain for a new organization before actuall domain validation can be done.


# Onboarding 12: New Cloud Identity users are flagged as User Suspended by default in admin security alert center - ignore - this is a red-herring
- 20220902: We will get to the root cause and determine the criteria for default suspension when creating a new org or importing identity users - for now you can ignore or reset the suspension (note: we need to know when the suspension is real)
- For example this org was onboarded from scratch and the super admin idenity user was already flagged as "User Suspended" - with no effects.

<img width="1429" alt="Screen Shot 2022-09-02 at 3 35 28 PM" src="https://user-images.githubusercontent.com/94715080/188225478-dc36ea8c-cb89-4f74-b86a-d759ea8a763d.png">

# Billing
## Billing Summary

- type 1: shared billing account where account owner in other org adds the super admin account in this org as a Billing Account Administrator and (usually missed) the terraform service account
- type 2: direct billing credit card on this account (all tests above so far are this case)
State of billing id associations for type 2 are the following (this one is for the guardrails install https://github.com/canada-ca/accelerators_accelerateurs-gcp/issues/47) - notice that the terraform service account is in the list as well as the user super admin account.

<img width="1412" alt="Screen Shot 2022-09-17 at 08 28 26" src="https://user-images.githubusercontent.com/24765473/190856982-365c23f0-110d-43f2-8cf9-b9b7e8d6f4ea.png">

### Shared Billing Accounts

TL;DR; Shared billing accounts do not get shared IAM roles - they need to be set separately

We need a workaround (see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/177 ) for the fact that if the billing account is of type "shared" - owned by a source organization where it comes in under the target organization as "Non Selected, ID=0" then any service account created will not get inherited links from IAM set in Billing - these like Billing Account User - need to be set manually.  The workaround is currently manual - set the billing role directy in Billing on the shared account.
See IAM Role inheritance into Billing Roles in https://cloud.google.com/billing/docs/how-to/billing-access


Example 
```
michael@cloudshell:~$ gcloud config set project gcp-zone-landing-stg
Updated property [core/project].
michael@cloudshell:~ (gcp-zone-landing-stg)$ export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
michael@cloudshell:~ (gcp-zone-landing-stg)$ export ORG_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
michael@cloudshell:~ (gcp-zone-landing-stg)$ export SA_PREFIX=tfsa-example
michael@cloudshell:~ (gcp-zone-landing-stg)$ gcloud iam service-accounts create "${SA_PREFIX}" --display-name "Terraform example service account" --project=${PROJECT_ID}
Created service account [tfsa-example].
michael@cloudshell:~ (gcp-zone-landing-stg)$ export SA_EMAIL=`gcloud iam service-accounts list --project="${PROJECT_ID}" --filter=tfsa --format="value(email)"`
michael@cloudshell:~ (gcp-zone-landing-stg)$ echo $SA_EMAIL
tfsa-example@gcp-zone-landing-stg.iam.gserviceaccount.com

check existing roles
michael@cloudshell:~ (gcp-zone-landing-stg)$ gcloud organizations get-iam-policy $ORG_ID --filter="bindings.members:$SA_EMAIL" --flatten="bindings[].members" --format="table(bindings.role)"

Set the billing role
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/billing.user

check again

michael@cloudshell:~ (gcp-zone-landing-stg)$ gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=serviceAccount:${SA_EMAIL} --role=roles/billing.user
Updated IAM policy for organization [925207728429].
...
michael@cloudshell:~ (gcp-zone-landing-stg)$ gcloud organizations get-iam-policy $ORG_ID --filter="bindings.members:$SA_EMAIL" --flatten="bindings[].members" --format="table(bindings.role)"

ROLE: roles/billing.user
```
It may take a couple min to show in IAM

<img width="1434" alt="Screen Shot 2022-09-18 at 19 01 36" src="https://user-images.githubusercontent.com/24765473/190931947-eed320aa-77af-440d-bfa2-0c944c6a3fa9.png">

Checking billing on the shared account

expected on billing accounts belonging to this org - via IAM inheritance in billing
<img width="1737" alt="Screen Shot 2022-09-18 at 19 04 02" src="https://user-images.githubusercontent.com/24765473/190931997-e6cc1729-1046-4a49-835a-bfa86d25c09b.png">

not expected on billing accounts shared from other orgs
<img width="1738" alt="Screen Shot 2022-09-18 at 19 04 49" src="https://user-images.githubusercontent.com/24765473/190932022-f0e48504-9e95-4bba-aff6-8cf18e76eb26.png">

Workaround - set manually
<img width="1733" alt="Screen Shot 2022-09-18 at 19 18 21" src="https://user-images.githubusercontent.com/24765473/190932409-a1541bc3-f1b6-4ff2-9f5f-e491ab9774de.png">

ref https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/177




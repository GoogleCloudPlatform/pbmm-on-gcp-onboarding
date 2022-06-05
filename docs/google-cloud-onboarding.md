Table Of Contents

* [Onboarding Category 1: GCP Workspace account - GCP Domain validation](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-1-workspace-email---gcp-domain)

* Onboarding Category 2: 3rd party email account - GCP Domain validation

* [Onboarding Category 3: Gmail Email with forwarding - GCP Domain validation](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-3-gmail-email---gcp-domain)

* Onboarding Category 3b: 3rd party email account - 3rd party (AWS Route53) domain validation

* [Onboarding Category 5c: second 3rd party Email - 3rd party Domain already verified](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-category-5-3rd-party-email---3rd-party-domain)

* Onboarding Category 9: Consumer Gmail account - no Domain




# Onboarding new Google Cloud Accounts using either gmail, workspaces or cloud identity

There are 2 primary steps when getting onboarded to cloud.  

https://cloud.google.com/billing/docs/onboarding-checklist

https://cloud.google.com/docs/enterprise/setup-checklist

#Google Cloud Onboarding Categories

There are two types of google cloud accounts (workspace and cloud identity).  Cloud Identity has 2 types of accounts (gmail and 3rd party based (such as AWS Workmail).  There are 3 types of DNS Zone configurations (none, Google Domains, 3rd Party (such as AWS Route53).  Therefore there are 9 types of onboarding categories (3 x 3).

see
https://console.cloud.google.com/cloud-setup/organization?organizationId=0&orgonly=true&supportedpurview=organizationId,folder,project

Workspaces accounts can also have cloud identity accounts

## Onboarding Category 1: Workspace Email -  GCP Domain

This category is the common workspace and GCP organization domain hosted on Google Domains use case.

Google workspace accounts are ideal for organizations that exist inside the Google ecosystem and subscribe to the workspaces services list.

Open an incognito chrome window.

<img width="1769" alt="Screen Shot 2022-06-05 at 08 23 13" src="https://user-images.githubusercontent.com/24765473/172050198-22c5b525-6cf7-4c27-aef5-33ca96925247.png">

Navigate to https://domains.google/ and Look for an open domain to match your business name if not already registered.

<img width="1769" alt="Screen Shot 2022-06-05 at 08 24 38" src="https://user-images.githubusercontent.com/24765473/172050241-dc9d22bc-99d4-4b56-a814-bb8c6d33c96b.png">

Here selecting for nuagecloud.ca - don't register this domain yet - you will in the following site

<img width="1769" alt="Screen Shot 2022-06-05 at 08 26 24" src="https://user-images.githubusercontent.com/24765473/172050329-f2d38f3f-d5c3-48f7-b5c4-4fb8bee2f4b3.png">

Navigate to creating a new workspace account https://workspace.google.com/business/signup/welcome

<img width="1770" alt="Screen Shot 2022-06-05 at 08 29 35" src="https://user-images.githubusercontent.com/24765473/172050451-ac9d24e0-980f-49d1-ac0d-fab492618e44.png">

Describe the main super admin or root account.

<img width="1766" alt="Screen Shot 2022-06-05 at 08 30 36" src="https://user-images.githubusercontent.com/24765473/172050528-75b8927b-8b55-4999-83fb-ce1da20e78b6.png">

Select "no" domain yet

<img width="1778" alt="Screen Shot 2022-06-05 at 08 31 21" src="https://user-images.githubusercontent.com/24765473/172050562-f5a3b75d-575a-417a-8528-6e9356eea83a.png">

Search for your domain - Note: ca domains will show in domain search before but not during workspaces domain search - use nuage-cloud.org

<img width="1772" alt="Screen Shot 2022-06-05 at 10 16 36" src="https://user-images.githubusercontent.com/24765473/172055017-970f3972-1981-479e-9d87-542ad53ec276.png">

<img width="1775" alt="Screen Shot 2022-06-05 at 10 17 59" src="https://user-images.githubusercontent.com/24765473/172055035-f9262497-08a8-47b3-b00d-b705e52c47b2.png">

Fill out super admin root account

<img width="1767" alt="Screen Shot 2022-06-05 at 10 19 16" src="https://user-images.githubusercontent.com/24765473/172055093-8f4a2b6c-fd20-4d71-a2f0-6a58e35efaef.png">

Get workspace

<img width="1777" alt="Screen Shot 2022-06-05 at 10 20 03" src="https://user-images.githubusercontent.com/24765473/172055124-676d384c-5ac9-40a9-ba1d-baded5d78d06.png">

Payment and registration info

<img width="1773" alt="Screen Shot 2022-06-05 at 10 21 18" src="https://user-images.githubusercontent.com/24765473/172055180-bed23bc6-ad6f-421d-ab1f-ef6ad16c2025.png">

Continue to admin.google.com

<img width="1772" alt="Screen Shot 2022-06-05 at 10 22 06" src="https://user-images.githubusercontent.com/24765473/172055236-f34015e4-8567-42d9-96bf-3f62c0fdf3cd.png">

Domain registration pending

<img width="1774" alt="Screen Shot 2022-06-05 at 10 22 32" src="https://user-images.githubusercontent.com/24765473/172055244-b3638c99-544e-4f4c-a145-d519976c7e49.png">

Check services (domain and workspace)

<img width="1775" alt="Screen Shot 2022-06-05 at 10 23 32" src="https://user-images.githubusercontent.com/24765473/172055284-ec163002-927e-4f93-bb97-1b23c62c0bb0.png">

Switch out of incognito and into a new Chrome profile

<img width="1014" alt="Screen Shot 2022-06-05 at 10 26 40" src="https://user-images.githubusercontent.com/24765473/172055419-9cbddee2-b825-48b3-957e-20822e6ed826.png">

<img width="1019" alt="Screen Shot 2022-06-05 at 10 27 28" src="https://user-images.githubusercontent.com/24765473/172055503-632a89b2-e7ef-41f6-b5a1-ed20d58fb964.png">

<img width="1018" alt="Screen Shot 2022-06-05 at 10 27 40" src="https://user-images.githubusercontent.com/24765473/172055508-655b9b6a-9560-4450-9945-5a663061fbb7.png">

<img width="1673" alt="Screen Shot 2022-06-05 at 10 28 13" src="https://user-images.githubusercontent.com/24765473/172055511-dbfe7454-842d-4ee4-8cc6-9bf998e30782.png">

Check super admin (workspace seed role) set - via Account | admin roles

<img width="1677" alt="Screen Shot 2022-06-05 at 10 29 08" src="https://user-images.githubusercontent.com/24765473/172055573-32d5995e-cf96-428d-858a-1b7a276454f5.png">

Activivate the trial

<img width="1672" alt="Screen Shot 2022-06-05 at 10 30 07" src="https://user-images.githubusercontent.com/24765473/172056445-64957e51-ab77-460c-a835-078cdd30e7d7.png">


<img width="1679" alt="Screen Shot 2022-06-05 at 10 30 19" src="https://user-images.githubusercontent.com/24765473/172056451-b54af622-7067-4318-bbfd-bc892993b8a8.png">

<img width="604" alt="Screen Shot 2022-06-05 at 10 30 27" src="https://user-images.githubusercontent.com/24765473/172056455-ea4722d3-51d9-4ffc-b826-118148697949.png">

<img width="1671" alt="Screen Shot 2022-06-05 at 10 30 52" src="https://user-images.githubusercontent.com/24765473/172056460-9a9af020-a442-4f46-8872-e2731da04251.png">

<img width="756" alt="Screen Shot 2022-06-05 at 10 31 03" src="https://user-images.githubusercontent.com/24765473/172056463-8f839aac-1dd6-4eeb-a4cf-f9a16f4e1aae.png">

Notice organization was created when you navigated to IAM | Identity & Organization

<img width="1674" alt="Screen Shot 2022-06-05 at 10 31 40" src="https://user-images.githubusercontent.com/24765473/172056470-e70236d6-3654-436f-aeba-688eb0925c92.png">

<img width="1676" alt="Screen Shot 2022-06-05 at 10 31 51" src="https://user-images.githubusercontent.com/24765473/172056476-9fd454a6-6234-4eb2-b56b-34615252c1a3.png">

However you still only have project access for "no organization"
<img width="1670" alt="Screen Shot 2022-06-05 at 10 32 56" src="https://user-images.githubusercontent.com/24765473/172056481-daeaa6bb-ca96-4ba1-943a-eabdcb2fe75a.png">

Activate the trial to get full service - this is a 2 step

<img width="1677" alt="Screen Shot 2022-06-05 at 10 33 10" src="https://user-images.githubusercontent.com/24765473/172056504-fd3c7fdd-117a-4740-a008-c3d5df453f40.png">

<img width="1673" alt="Screen Shot 2022-06-05 at 10 33 39" src="https://user-images.githubusercontent.com/24765473/172056510-0a805854-16d1-45ae-a53e-a4a330f5216e.png">

<img width="1675" alt="Screen Shot 2022-06-05 at 10 34 12" src="https://user-images.githubusercontent.com/24765473/172056521-4dda0433-d8b2-4d9c-ac2a-8a8487e0f181.png">

<img width="612" alt="Screen Shot 2022-06-05 at 10 35 08" src="https://user-images.githubusercontent.com/24765473/172056531-870bf9d7-c027-44e0-bf5f-246c4a65a933.png">

<img width="1678" alt="Screen Shot 2022-06-05 at 10 35 40" src="https://user-images.githubusercontent.com/24765473/172056541-af79f786-d0dc-43ad-b258-ea0114b27785.png">

In order to be able to select for the organization - log out and activate your full account - this will populate the organization level

<img width="1661" alt="Screen Shot 2022-06-05 at 10 45 20" src="https://user-images.githubusercontent.com/24765473/172056358-4f7f420b-5eb6-4b68-b84b-55a8c9d4f506.png">

<img width="1666" alt="Screen Shot 2022-06-05 at 10 45 30" src="https://user-images.githubusercontent.com/24765473/172056368-46c56316-c21c-4975-bc4d-daaf35f28625.png">

<img width="1668" alt="Screen Shot 2022-06-05 at 10 45 44" src="https://user-images.githubusercontent.com/24765473/172056374-6dcc9c78-7a72-47fc-805a-e098b09057aa.png">

<img width="1664" alt="Screen Shot 2022-06-05 at 10 46 07" src="https://user-images.githubusercontent.com/24765473/172056381-a8bfdb39-4ef1-4191-981a-2049cf8d779c.png">

<img width="1668" alt="Screen Shot 2022-06-05 at 10 46 26" src="https://user-images.githubusercontent.com/24765473/172056383-0f11aa21-8352-4712-9376-edbed2043f53.png">

Verify your email address for domain registration by 14 days 

<img width="773" alt="Screen Shot 2022-06-05 at 11 08 14" src="https://user-images.githubusercontent.com/24765473/172057273-09a32553-83e0-4d2f-8ddf-96d3cafba3f8.png">


Notice the default roles at the organization level

admin-root super admin user (Organization Administrator)

nuage-cloud.org organization (Billing Account Creator, Project Creator)

You will want to add to admin-root (Owner, Folder Admin)

<img width="1662" alt="Screen Shot 2022-06-05 at 10 57 09" src="https://user-images.githubusercontent.com/24765473/172056846-a796853f-b7e6-4edd-98c3-5b8fb45c3791.png">

<img width="1664" alt="Screen Shot 2022-06-05 at 10 57 19" src="https://user-images.githubusercontent.com/24765473/172056851-c17e598a-0027-483f-b370-e0e672b5a006.png">

Test the folder admin role by creating a folder we will use for temporary test projects.

<img width="1667" alt="Screen Shot 2022-06-05 at 10 57 57" src="https://user-images.githubusercontent.com/24765473/172056857-8f2f0460-7411-4f3c-888f-e9db02ebada0.png">

Refresh the browser to check

<img width="1675" alt="Screen Shot 2022-06-05 at 10 58 27" src="https://user-images.githubusercontent.com/24765473/172056860-112e00f3-91ad-4b9a-bc82-fc3ff52a5261.png">

Create 5 more projects in this folder - we will delete them after we increase billing quota.
<img width="1667" alt="Screen Shot 2022-06-05 at 10 57 57" src="https://user-images.githubusercontent.com/24765473/172057003-f80d76d6-eae6-4ff9-957e-df83298a521c.png">

<img width="1671" alt="Screen Shot 2022-06-05 at 11 02 46" src="https://user-images.githubusercontent.com/24765473/172057009-3bed2530-d3c7-45fe-9f87-87b10fa3e369.png">

Goto billing - select my projects

<img width="1674" alt="Screen Shot 2022-06-05 at 11 03 50" src="https://user-images.githubusercontent.com/24765473/172057166-20d1f221-bd1a-407e-aaff-961ce521ebdb.png">

Notice the 6th project has billing disabled

<img width="1670" alt="Screen Shot 2022-06-05 at 11 04 01" src="https://user-images.githubusercontent.com/24765473/172057176-2b2d3ba4-63e4-417c-80f8-ea04001920e3.png">

<img width="513" alt="Screen Shot 2022-06-05 at 11 04 32" src="https://user-images.githubusercontent.com/24765473/172057181-132ecd4e-8cc7-42d9-a1cb-1c585c8a3472.png">

Attempt to change billing on the 6th project

<img width="555" alt="Screen Shot 2022-06-05 at 11 04 39" src="https://user-images.githubusercontent.com/24765473/172057185-ad218feb-6187-4846-b407-f0aeffc1782f.png">

Submit the quota increase

<img width="1663" alt="Screen Shot 2022-06-05 at 11 05 45" src="https://user-images.githubusercontent.com/24765473/172057188-1260a4f6-82b3-4d9c-b156-654678f1ff9a.png">

<img width="1660" alt="Screen Shot 2022-06-05 at 11 05 55" src="https://user-images.githubusercontent.com/24765473/172057198-860fa182-e4b7-487d-9ba5-9f944dcf76be.png">

The billing account default project association uota of 5 is per billing account - another option is to create additional accounts on the same or different payment method


<img width="1665" alt="Screen Shot 2022-06-05 at 11 24 46" src="https://user-images.githubusercontent.com/24765473/172058013-9aa6fac3-58de-441a-8c76-2ba17f0cd95f.png">

<img width="1667" alt="Screen Shot 2022-06-05 at 11 25 16" src="https://user-images.githubusercontent.com/24765473/172058016-6d6e8cfd-37a6-48eb-87c1-1e6e820369a3.png">

<img width="1664" alt="Screen Shot 2022-06-05 at 11 26 24" src="https://user-images.githubusercontent.com/24765473/172058020-8075517c-8180-4777-a55e-7d7a8b91af50.png">



Also there is an 8 project quota we will need to increase






### Increasing Quotas
Ask for 20 from the default 5 for project/billing association - create 6 projects and assign billing on the 6th to get the popup.
Select "paid services" and you will get approved in 3 min.



### Enabling Services








## Onboarding Category 2: 3rd party Email -  GCP Domain

This category is where the client uses their own email system but has the organization domain with GCP

## Onboarding Category 3: Gmail Email -  GCP Domain

This cloud identity category is where the client uses a new gmail email with optional redirect records on a GCP hosted domain for their organization.  Here the gmail address is a formality - you could use your own 3rd party email

We will be using a domain from another google account that owns the domain we will use in our new account for the org (at this point we are using Google Domains as the DNS zone)

<img width="1521" alt="3-1" src="https://user-images.githubusercontent.com/94715080/169097134-887b7449-4c08-456b-bf42-917b5da5cebb.png">

Start with an incognito chrome window and goto https://accounts.google.com/SignUpWithoutGmail

<img width="1044" alt="3-2" src="https://user-images.githubusercontent.com/94715080/169103590-68bce93e-c2ec-4f65-b91b-7c93be53e890.png">

create your new cloud identity account

<img width="1500" alt="3-3" src="https://user-images.githubusercontent.com/94715080/169103623-f0628cf6-627b-4373-9cf5-186813aca0e6.png">

select new gmail

<img width="1509" alt="3-4" src="https://user-images.githubusercontent.com/94715080/169103708-49005a33-8d1d-4f47-b7ef-2f0e6b975904.png">

fill in the account details

<img width="1166" alt="3-5" src="https://user-images.githubusercontent.com/94715080/169103739-d0c14b66-a68a-48f1-841e-b2a81aa9620e.png">

verify MFA

<img width="1518" alt="3-6" src="https://user-images.githubusercontent.com/94715080/169103768-3a1db456-d4bb-4d7d-85d5-9b187a50dedc.png">

gmail account created

<img width="484" alt="3-7" src="https://user-images.githubusercontent.com/94715080/169103836-125c5eb5-b0c3-406c-bf20-3b243567d079.png">

Check account

<img width="1514" alt="3-8" src="https://user-images.githubusercontent.com/94715080/169103890-9e76953b-5f52-4e4e-950e-000f9ebf2c8f.png">

Start a new chrome profile for the initial gmail account

<img width="1011" alt="3-9" src="https://user-images.githubusercontent.com/94715080/169103919-4d8a8192-84f1-44c6-8a4d-35431397c31d.png">

Sign in

<img width="1013" alt="3-10" src="https://user-images.githubusercontent.com/94715080/169103952-683b8ec3-4f0d-48ec-a2ae-596323883b9d.png">

Select account

<img width="1523" alt="3-11" src="https://user-images.githubusercontent.com/94715080/169103966-129462b6-0b1e-4f00-a99a-24f23bdcf6d3.png">

Choose gmail account

<img width="1004" alt="3-12" src="https://user-images.githubusercontent.com/94715080/169103996-a718f57d-d1ee-4dfa-a217-2bd16d50d4f5.png">

Goto console.cloud.google.com

<img width="445" alt="3-13" src="https://user-images.githubusercontent.com/94715080/169104017-dc0d0c28-b7fb-492a-9177-98fef3cf6585.png">

we won't be using this account but lets verify we don't have an organization yet

<img width="1503" alt="3-14" src="https://user-images.githubusercontent.com/94715080/169104060-7bdb7960-ec4e-4820-b1e4-be0c80dcf2ab.png">

Goto IAM

<img width="1524" alt="3-15" src="https://user-images.githubusercontent.com/94715080/169104091-eb51db01-0b2e-4f31-a431-35abf9fe6f6f.png">

Check Identity & Organization

<img width="886" alt="3-17" src="https://user-images.githubusercontent.com/94715080/169104114-f3773a09-d800-4721-ac02-651429791332.png">

Verify no organization rights yet

<img width="1516" alt="3-18" src="https://user-images.githubusercontent.com/94715080/169104355-35c904c0-4080-4188-a85f-6ba6aee68ccc.png">

Scroll down to add a new cloud identity account

<img width="1526" alt="3-19" src="https://user-images.githubusercontent.com/94715080/169104384-965f7e9a-c824-4d87-8d34-9c35f820bfea.png">

Select I am a new customer

<img width="585" alt="3-20" src="https://user-images.githubusercontent.com/94715080/169104428-0fb2fd1f-c1dd-4e48-a88c-413a6de0a63b.png">


Start the cloud identity wizard

<img width="1520" alt="3-21" src="https://user-images.githubusercontent.com/94715080/169104574-ce544af5-d3ad-44c3-8471-1a85263987eb.png">

fill in your org

<img width="1512" alt="3-22" src="https://user-images.githubusercontent.com/94715080/169104598-a2c16544-f9fe-4f8c-86d0-52aa84773e2c.png">

use the gmail account as base - or your own email

<img width="1518" alt="3-23" src="https://user-images.githubusercontent.com/94715080/169104631-cc293b2a-e1fc-4c26-80f5-4ad90c8001e0.png">

Here - the domain name is important - usually you will not verify/use the base domain - create a subdomain like gcp.* - here business name = domain

<img width="1516" alt="3-24" src="https://user-images.githubusercontent.com/94715080/169104653-f6395cb7-25e9-4b87-967d-7d91fa0ff772.png">

See the same subdomain (from the business name) - notice the warning on email redirection - we will setup this in the domain owner account

<img width="1522" alt="3-25" src="https://user-images.githubusercontent.com/94715080/169104692-ed482a0c-df15-4d1e-822e-da2994732b3f.png">

Switch windows to the account owning the domain - select email on the left - see no email forwarding record yet 

<img width="1528" alt="3-26a" src="https://user-images.githubusercontent.com/94715080/169104721-59836309-d048-4f3e-9afd-830898abc20a.png">

Fill in the email forwarding to your gmail email - use the super admin account you will create later in cloud identity

<img width="1520" alt="3-27a" src="https://user-images.githubusercontent.com/94715080/169104792-b200b423-421c-40ac-925b-316ba0090b41.png">

View the change - we will test propagation - usually less than 1 min - click send test email

<img width="1522" alt="3-28a" src="https://user-images.githubusercontent.com/94715080/169104828-2a87ef75-018c-45c3-8984-566425565746.png">

This will open gmail - click the verify - don't worry as even though this gmail account is not the account owning the domain - the test email will get sent

<img width="1530" alt="3-29" src="https://user-images.githubusercontent.com/94715080/169104932-a648f8cd-cdee-405e-a16f-d2accb228921.png">

You can ignore the domains check - not the right chrome account

<img width="1526" alt="3-30" src="https://user-images.githubusercontent.com/94715080/169105133-49dfec72-c411-40f5-8b84-d228ff3f4f15.png">

send your own test email to verify the redirect -from the new super admin account to your email

<img width="597" alt="3-31" src="https://user-images.githubusercontent.com/94715080/169105169-40e6cb6d-6a21-45b1-b5e7-1e24f490009a.png">

Check the email was forwarded to gmail

<img width="1530" alt="3-32" src="https://user-images.githubusercontent.com/94715080/169105205-b0b2f165-2d48-4b03-be27-531a71692f78.png">

Go back to the cloud identity wizard and click next to get to the new super admin account setup

<img width="1523" alt="3-33" src="https://user-images.githubusercontent.com/94715080/169105684-31f9cd8d-3acc-4a8c-a719-42f255020e60.png">

<img width="1522" alt="3-34" src="https://user-images.githubusercontent.com/94715080/169105720-ce76b314-b457-4adb-905e-f339483d62d0.png">

accept the new account

<img width="1516" alt="3-35" src="https://user-images.githubusercontent.com/94715080/169106023-7dc58527-f9b5-4697-ac68-b50cde6dd18e.png">

verify account

<img width="1523" alt="3-36" src="https://user-images.githubusercontent.com/94715080/169106716-2bb6b24e-9db4-41a6-a44c-30d37ea447b0.png">


Click the setup button

<img width="1528" alt="3-37" src="https://user-images.githubusercontent.com/94715080/169106752-f66d6e2d-3356-4338-9e07-8d627ae1dad3.png">

Sign in to your cloud identity super admin account

<img width="1527" alt="3-38" src="https://user-images.githubusercontent.com/94715080/169106802-078b0541-2503-46cc-9d83-b8234e2baffa.png">

Accept MFA

<img width="1526" alt="3-39" src="https://user-images.githubusercontent.com/94715080/169106856-5c00ff98-047d-4b10-a412-ecbda7682a04.png">

<img width="1518" alt="3-40" src="https://user-images.githubusercontent.com/94715080/169106882-abac7b23-b2ae-4383-ac9d-eb387008546c.png">

Cloud identity account created

<img width="1524" alt="3-41" src="https://user-images.githubusercontent.com/94715080/169106910-053b28ae-014e-4e65-a6d2-5d93a7d3f281.png">

<img width="1522" alt="3-42" src="https://user-images.githubusercontent.com/94715080/169106937-df59e280-58bd-4a82-9008-dfe68f13da8d.png">

Here we setup the organization and domain verify - click verify

<img width="1518" alt="3-43" src="https://user-images.githubusercontent.com/94715080/169106989-c31d1a78-e34e-4f98-a1a2-71719794f488.png">

Check "switch verification method" - there are 2 - we will use a TXT record - you can email/copy this code manually

<img width="1524" alt="3-44" src="https://user-images.githubusercontent.com/94715080/169107030-34f7d874-04ad-4af1-af12-e3d663964c77.png">

select TXT

<img width="1526" alt="3-45" src="https://user-images.githubusercontent.com/94715080/169107063-36ebe5e2-a056-48e2-a0bf-c105e63d86e2.png">

<img width="1527" alt="3-46" src="https://user-images.githubusercontent.com/94715080/169107091-38a76562-3146-4a51-8fa9-c478ac0f90f0.png">

Copy the TXT verification text

<img width="1520" alt="3-47" src="https://user-images.githubusercontent.com/94715080/169107129-e719024c-69fb-4551-b446-a0553b348315.png">

In the account owning the domain (after switching windows or sending to IT) - go back to your DNS zone records (Google Domains or AWS Route53)

<img width="1524" alt="3-48a" src="https://user-images.githubusercontent.com/94715080/169107181-c9436dc0-fc06-4bc6-a907-d48941aebf25.png">

Add custom record - here we add the "gcp" subdomain in the host name and the TXT record in the data - selet type TXT

<img width="1523" alt="3-49a" src="https://user-images.githubusercontent.com/94715080/169107211-e41f7b9a-0cab-498a-a9cc-affc8c9ad7ad.png">

Add record page - scrol down 

<img width="1528" alt="3-50a" src="https://user-images.githubusercontent.com/94715080/169107234-259efa61-2f12-45ed-b5b8-c461363dedf2.png">

select "verify domain" - wait for DNS propagation < 1 min

<img width="1525" alt="3-51" src="https://user-images.githubusercontent.com/94715080/169107271-5fa60041-401a-4663-8bd1-76793aeb5ea1.png">

Notice domain record being checked - we will check ourselves with dig

<img width="1541" alt="3-52" src="https://user-images.githubusercontent.com/94715080/169107297-1b10411f-b865-4722-88b8-9ebecf35a1ed.png">

run a dig on the subdomain

<img width="989" alt="3-53b" src="https://user-images.githubusercontent.com/94715080/169107335-bd1c494f-8a28-49e7-99e3-0e3bda996325.png">

Cloud identity screen will change to "verified"

<img width="1522" alt="3-54" src="https://user-images.githubusercontent.com/94715080/169107353-ae578ac5-4141-47c1-833e-018b1f6b4806.png">

log into your new cloud identity super admin account using console.cloud.google.com

<img width="1524" alt="3-55" src="https://user-images.githubusercontent.com/94715080/169107401-ea5d8135-ecd8-4a98-bf07-f8b469cc22e3.png">

Organization will auto create - first time entering IAM

<img width="609" alt="3-56" src="https://user-images.githubusercontent.com/94715080/169107437-65dce692-75b3-49e5-9ada-2f27c35da02d.png">

Try selecting a project - better to create a new chrome profile to see the org

<img width="1521" alt="3-57" src="https://user-images.githubusercontent.com/94715080/169107458-efe71f67-cf77-4de8-b5ec-5f067ac87834.png">

Create new chrome profile for the user (to get away from the gmail bootstrap account)

<img width="1014" alt="3-58b" src="https://user-images.githubusercontent.com/94715080/169107480-6da8d732-3fab-4ded-8bad-0e2c35f55a3f.png">

Sign in

<img width="1017" alt="3-59b" src="https://user-images.githubusercontent.com/94715080/169107553-02163208-4ca6-43e3-8dce-6e67aa76d4c5.png">

<img width="1013" alt="3-60b" src="https://user-images.githubusercontent.com/94715080/169107591-d73a3a74-2113-46f3-83db-3fa6e98ebf2f.png">

Select profile

<img width="1524" alt="3-61b" src="https://user-images.githubusercontent.com/94715080/169107615-d76d5fc6-66a8-47bb-afae-9e0dd7ef7c28.png">

Goto admin.google.com to verify SA user and subdomain

<img width="1509" alt="3-62b" src="https://user-images.githubusercontent.com/94715080/169107645-bae87f2b-912e-4b66-add2-f57ec46010b3.png">

Login to console.cloud.google.com - goto IAM - select a project - notice the organization dropdown

<img width="1528" alt="3-63b" src="https://user-images.githubusercontent.com/94715080/169107680-f7b9af00-d1f5-4556-8653-91f465b10e99.png">

Select the new organization

<img width="1531" alt="3-64b" src="https://user-images.githubusercontent.com/94715080/169107702-1ff52a02-a630-42f2-ba09-4feb7fb077c1.png">

View IAM super admin has the organization administrator role

<img width="1529" alt="3-65b" src="https://user-images.githubusercontent.com/94715080/169107734-e6cdedd6-872e-4166-9689-3ceb3bbc6b68.png">






## Onboarding Category 5: 3rd party Email - 3rd party Domain

This category is common for organizations new to GCP or multicloud where both the email system and DNS hosting zone are 3rd party

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



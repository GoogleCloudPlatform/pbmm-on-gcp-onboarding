Table Of Contents
* [Onboarding Category 3: Gmail Email -  GCP Domain](https://github.com/cloud-quickstart/wiki/blob/main/google-cloud-onboarding.md#onboarding-category-3-gmail-email---gcp-domain)

* [Category 5c: second 3rd party Email - 3rd party Domain already verified](https://github.com/cloud-quickstart/wiki/blob/main/google-cloud-onboarding.md#category-5c-second-3rd-party-email---3rd-party-domain-already-verified)




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

<img width="1520" alt="Screen Shot 2022-05-12 at 5 35 25 PM" src="https://user-images.githubusercontent.com/94715080/168197536-1824392b-c5e4-4551-9fef-3f3736ab9665.png">

fill in your org

<img width="1512" alt="Screen Shot 2022-05-12 at 5 36 15 PM" src="https://user-images.githubusercontent.com/94715080/168197576-096d6029-261b-415a-a1ae-e00a9e78cfd5.png">

use the gmail account as base - or your own email

<img width="1518" alt="Screen Shot 2022-05-12 at 5 36 47 PM" src="https://user-images.githubusercontent.com/94715080/168197624-4e87b933-85c4-46cf-be19-43d48979f286.png">

Here - the domain name is important - usually you will not verify/use the base domain - create a subdomain like gcp.* - here business name = domain

<img width="1516" alt="Screen Shot 2022-05-12 at 5 37 30 PM" src="https://user-images.githubusercontent.com/94715080/168197681-df63bea4-60bd-425a-a5b3-c3339ca2ffc8.png">

See the same subdomain (from the business name) - notice the warning on email redirection - we will setup this in the domain owner account

<img width="1522" alt="Screen Shot 2022-05-12 at 5 37 47 PM" src="https://user-images.githubusercontent.com/94715080/168197746-23bca972-0145-483b-bbdc-e4d7433068bb.png">

Switch windows to the account owning the domain - select email on the left - see no email forwarding record yet 

<img width="1528" alt="Screen Shot 2022-05-12 at 5 38 11 PM" src="https://user-images.githubusercontent.com/94715080/168197789-24a48bba-d719-4b8c-8252-ffae6d04157f.png">

Fill in the email forwarding to your gmail email - use the super admin account you will create later in cloud identity

<img width="1520" alt="Screen Shot 2022-05-12 at 5 39 03 PM" src="https://user-images.githubusercontent.com/94715080/168197821-db60dddc-43d1-4068-8e72-9df147fc1d98.png">

View the change - we will test propagation - usually less than 1 min - click send test email

<img width="1522" alt="Screen Shot 2022-05-12 at 5 39 28 PM" src="https://user-images.githubusercontent.com/94715080/168197832-99bf69a8-2a31-4fac-b0bb-29baea3d5f7e.png">

This will open gmail - click the verify - don't worry as even though this gmail account is not the account owning the domain - the test email will get sent

<img width="1530" alt="Screen Shot 2022-05-12 at 5 39 57 PM" src="https://user-images.githubusercontent.com/94715080/168197838-e11b789d-9523-4daa-b4d8-cf3ff17c1741.png">

You can ignore the domains check - not the right chrome account

<img width="1526" alt="Screen Shot 2022-05-12 at 5 40 18 PM" src="https://user-images.githubusercontent.com/94715080/168197860-ea65424c-d428-4c80-b91a-6d8881cf1a59.png">

send your own test email to verify the redirect -from the new super admin account to your email

<img width="597" alt="Screen Shot 2022-05-12 at 5 41 26 PM" src="https://user-images.githubusercontent.com/94715080/168197897-8b58ce4a-234a-42ad-9452-05ebd8041ea3.png">

Check the email was forwarded to gmail

<img width="1530" alt="Screen Shot 2022-05-12 at 5 41 54 PM" src="https://user-images.githubusercontent.com/94715080/168197911-3e21f0b2-337c-4525-bf46-580c06dbb688.png">

Go back to the cloud identith wizard and click next to get to the new super admin account setup

<img width="1523" alt="Screen Shot 2022-05-12 at 5 42 23 PM" src="https://user-images.githubusercontent.com/94715080/168197932-f0f4d71d-af5f-42c2-9593-633a41eb5689.png">

<img width="1522" alt="Screen Shot 2022-05-12 at 5 42 41 PM" src="https://user-images.githubusercontent.com/94715080/168197944-fda9f27c-2e9d-4e95-b6e8-f42ce75c5135.png">

accept the new account

<img width="1516" alt="Screen Shot 2022-05-12 at 5 42 49 PM" src="https://user-images.githubusercontent.com/94715080/168197949-a0890121-fc8b-4742-ade3-c35695052c41.png">

verify account

<img width="1523" alt="Screen Shot 2022-05-12 at 5 43 21 PM" src="https://user-images.githubusercontent.com/94715080/168197954-dd4c73d4-2a2b-4b77-890b-b997fc6a019b.png">

Click the setup button

<img width="1528" alt="Screen Shot 2022-05-12 at 5 43 37 PM" src="https://user-images.githubusercontent.com/94715080/168197965-34dec9bd-be7e-420a-a33f-dc6aa11655af.png">

Sign in to your cloud identity super admin account

<img width="1527" alt="Screen Shot 2022-05-12 at 5 43 50 PM" src="https://user-images.githubusercontent.com/94715080/168197971-573af15f-16be-4e7a-8551-ab134c51a727.png">

Accept MFA

<img width="1526" alt="Screen Shot 2022-05-12 at 5 44 13 PM" src="https://user-images.githubusercontent.com/94715080/168197977-f5e231aa-a0b6-4428-ab9a-8f528731c3ff.png">

<img width="1518" alt="Screen Shot 2022-05-12 at 5 45 11 PM" src="https://user-images.githubusercontent.com/94715080/168197992-77899017-e166-403a-b07e-8799cc730e7e.png">

Cloud identity account created

<img width="1524" alt="Screen Shot 2022-05-12 at 5 45 18 PM" src="https://user-images.githubusercontent.com/94715080/168197999-f0280c49-40e9-46fd-87a6-d008cb55d2c6.png">

<img width="1522" alt="Screen Shot 2022-05-12 at 5 45 31 PM" src="https://user-images.githubusercontent.com/94715080/168198009-edbad099-e048-40ed-a95b-a014bf9ca361.png">

Here we setup the organization and domain verify - click verify

<img width="1518" alt="Screen Shot 2022-05-12 at 5 45 48 PM" src="https://user-images.githubusercontent.com/94715080/168198021-6c0216bd-0aff-4c94-a353-2f6fec2b3231.png">

Check "switch verification method" - there are 2 - we will use a TXT record - you can email/copy this code manually

<img width="1524" alt="Screen Shot 2022-05-12 at 5 46 12 PM" src="https://user-images.githubusercontent.com/94715080/168198039-cb806a23-4a11-47cc-a7b6-09dcde6ed133.png">

select TXT

<img width="1526" alt="Screen Shot 2022-05-12 at 5 46 37 PM" src="https://user-images.githubusercontent.com/94715080/168198055-b25521df-60aa-4e0c-8a52-005416ed4d29.png">

<img width="1527" alt="Screen Shot 2022-05-12 at 5 47 00 PM" src="https://user-images.githubusercontent.com/94715080/168198064-3cd9e885-5436-4089-a841-1ea8dab3464f.png">

Copy the TXT verification text

<img width="1520" alt="Screen Shot 2022-05-12 at 5 47 35 PM" src="https://user-images.githubusercontent.com/94715080/168198075-ad86504e-727e-4528-ab69-c978e546eee8.png">

in the account owning the domain (after switching windows or sending to IT) - go back to your DNS zone records (Google Domains or AWS Route53)

<img width="1524" alt="Screen Shot 2022-05-12 at 5 48 33 PM" src="https://user-images.githubusercontent.com/94715080/168198087-d1393173-4fdf-4ebc-9e4d-f34651006878.png">

Add custom record - here we add the "gcp" subdomain in the host name and the TXT record in the data - selet type TXT

<img width="1523" alt="Screen Shot 2022-05-12 at 5 49 20 PM" src="https://user-images.githubusercontent.com/94715080/168198096-d078f6a7-3e18-4948-8fa0-741579bac9bc.png">

Add record page - scrol down 

<img width="1528" alt="Screen Shot 2022-05-12 at 5 49 42 PM" src="https://user-images.githubusercontent.com/94715080/168198109-b2adfcb5-0d5d-40b4-a8dd-3316db0572ce.png">

select "verify domain" - wait for DNS propagation < 1 min

<img width="1525" alt="Screen Shot 2022-05-12 at 5 50 10 PM" src="https://user-images.githubusercontent.com/94715080/168198123-b57de36c-e328-4e7c-88aa-8cd6f4f21bb3.png">

Notice domain record being checked - we will check ourselves with dig

<img width="1541" alt="Screen Shot 2022-05-12 at 5 50 17 PM" src="https://user-images.githubusercontent.com/94715080/
168198142-a0322af6-2b20-4196-9248-f6ec2295bb5f.png">

run a dig on the subdomain

<img width="989" alt="Screen Shot 2022-05-12 at 5 50 54 PM" src="https://user-images.githubusercontent.com/94715080/168198148-1144eccc-b164-49b2-88a8-a92d4ddac191.png">

Cloud identity screen will change to "verified"

<img width="1522" alt="Screen Shot 2022-05-12 at 5 51 24 PM" src="https://user-images.githubusercontent.com/94715080/168198162-20a0e116-b5e0-443f-82c1-7089d025bfba.png">

log into your new cloud identity super admin account using console.cloud.google.com

<img width="1524" alt="Screen Shot 2022-05-12 at 5 52 02 PM" src="https://user-images.githubusercontent.com/94715080/168198199-f2a919f6-62d9-4602-bbbb-a732234b73bd.png">

Organization will auto create - first time entering IAM

<img width="609" alt="Screen Shot 2022-05-12 at 5 52 11 PM" src="https://user-images.githubusercontent.com/94715080/168198214-e48ea163-1988-435c-801b-4825f5049e05.png">

Try selecting a project - better to create a new chrome profile to see the org

<img width="1521" alt="Screen Shot 2022-05-12 at 5 52 28 PM" src="https://user-images.githubusercontent.com/94715080/168198226-6edb7112-3c43-490c-8e4e-c20755bd21c6.png">

Create new chrome profile for the user (to get away from the gmail bootstrap account)

<img width="1014" alt="Screen Shot 2022-05-12 at 5 54 41 PM" src="https://user-images.githubusercontent.com/94715080/168198276-cce85cab-ac3c-428c-b477-25134f76e0eb.png">

Sign in

<img width="1017" alt="Screen Shot 2022-05-12 at 5 55 00 PM" src="https://user-images.githubusercontent.com/94715080/168198289-1b54b816-3778-498d-9ec8-b247cfe0755b.png">

<img width="1013" alt="Screen Shot 2022-05-12 at 5 55 20 PM" src="https://user-images.githubusercontent.com/94715080/168198305-315927f4-d292-41f4-9fca-7b66667a3e6c.png">

Select profile

<img width="1524" alt="Screen Shot 2022-05-12 at 5 55 31 PM" src="https://user-images.githubusercontent.com/94715080/168198314-181665a2-f630-40c4-b5d4-ea3e7603d7b2.png">

Goto admin.google.com to verify SA user and subdomain

<img width="1509" alt="Screen Shot 2022-05-12 at 5 55 56 PM" src="https://user-images.githubusercontent.com/94715080/168198323-def3047b-49f1-472f-836a-4020d9736ee6.png">

Login to console.cloud.google.com - goto IAM - select a project - notice the organization dropdown

<img width="1528" alt="Screen Shot 2022-05-12 at 5 56 28 PM" src="https://user-images.githubusercontent.com/94715080/168198341-3d4069c8-97ff-46cb-83b2-e7c72d604442.png">

Select the new organization

<img width="1531" alt="Screen Shot 2022-05-12 at 5 56 35 PM" src="https://user-images.githubusercontent.com/94715080/168198359-988b6aab-6b4c-45de-845f-8490e8918385.png">

View IAM super admin has the organization administrator role

<img width="1529" alt="Screen Shot 2022-05-12 at 5 56 51 PM" src="https://user-images.githubusercontent.com/94715080/168198368-bba0fc5b-7c2e-4809-94ec-4e8e777c1928.png">



## Onboarding Category 5: 3rd party Email - 3rd party Domain

This category is common for organizations new to GCP or multicloud where both the email system and DNS hosting zone are 3rd party

### Category 5a: First 3rd party Email - 3rd party Domain requires TXT verification

### Category 5b: First 3rd party Email - 3rd party Domain requires indirect verification
Usually copy/paste or email


### Category 5c: second 3rd party Email - 3rd party Domain already verified
- using the original super admin/owner create another cloud identity account with an email on the organization domain - with optional email forward to their work email.  Give rights such as "Owner" or "Folder Admin" to this 2nd+ user, when they login to console.cloud.google.com they will already have proper access to the organization (no domain validation required)



goto the admin page at admin.google.com

<img width="784" alt="Screen Shot 2022-05-12 at 4 25 08 PM" src="https://user-images.githubusercontent.com/94715080/168198678-112aea4d-5c95-4c64-a6db-3cd01ee0ea46.png">

Add the new user - using an existing super admin user

<img width="1202" alt="Screen Shot 2022-05-12 at 4 25 30 PM" src="https://user-images.githubusercontent.com/94715080/168198702-df2d5268-4720-45de-91c7-cbf1a0411daa.png">

send login instructions - with temp password

<img width="949" alt="Screen Shot 2022-05-12 at 4 26 49 PM" src="https://user-images.githubusercontent.com/94715080/168198722-f6d277d2-cb1e-4660-b51c-09235a38ed49.png">

Start witn an incognito chrome window

<img width="1527" alt="Screen Shot 2022-05-12 at 4 20 49 PM" src="https://user-images.githubusercontent.com/94715080/168198608-ece10a2e-4197-4b63-a95e-208d657b1e14.png">

launch accounts.google.com

<img width="665" alt="Screen Shot 2022-05-12 at 4 28 21 PM" src="https://user-images.githubusercontent.com/94715080/168198735-327d0ff8-284a-48ab-89aa-dbec9871c185.png">

Login to new user

<img width="1017" alt="Screen Shot 2022-05-12 at 4 28 49 PM" src="https://user-images.githubusercontent.com/94715080/168198749-09c95b9c-3264-41a0-9be7-0a0a650575f5.png">

new account splash

<img width="1125" alt="Screen Shot 2022-05-12 at 4 29 11 PM" src="https://user-images.githubusercontent.com/94715080/168198781-795f5634-4ce9-419a-856f-6810ff14eb9e.png">

auto change password

<img width="965" alt="Screen Shot 2022-05-12 at 4 29 30 PM" src="https://user-images.githubusercontent.com/94715080/168198792-345b48c7-6975-4042-9b92-9d428d7b0bb3.png">

view new account

<img width="1192" alt="Screen Shot 2022-05-12 at 4 29 46 PM" src="https://user-images.githubusercontent.com/94715080/168198796-02db494d-8039-4b96-aec3-3901bc19d155.png">

select profile picture on top right - add (to get a new chrome profile for the user)

<img width="1021" alt="Screen Shot 2022-05-12 at 4 30 07 PM" src="https://user-images.githubusercontent.com/94715080/168198806-554b478e-c45b-44b3-bca4-ca084596ac7f.png">

login again

<img width="1019" alt="Screen Shot 2022-05-12 at 4 30 25 PM" src="https://user-images.githubusercontent.com/94715080/168198816-7952c8f8-1ec6-4f6d-b67b-bc99a015277e.png">

accept profile

<img width="1020" alt="Screen Shot 2022-05-12 at 4 31 03 PM" src="https://user-images.githubusercontent.com/94715080/168198824-13d46777-3462-420a-be8d-89f4b0c922aa.png">

Navigate to the cloud at console.cloud.google.com

<img width="482" alt="Screen Shot 2022-05-12 at 4 31 46 PM" src="https://user-images.githubusercontent.com/94715080/168198838-95c23cbe-29ee-4493-8424-7c3dada3837b.png">

Accept the license

<img width="1524" alt="Screen Shot 2022-05-12 at 4 32 01 PM" src="https://user-images.githubusercontent.com/94715080/168198851-5ec6473f-1499-477e-942d-cbe0e5b26d7d.png">

View that you are already on the existing organization (no DNS verify required)

<img width="1515" alt="Screen Shot 2022-05-12 at 4 32 25 PM" src="https://user-images.githubusercontent.com/94715080/168198865-787b7fde-deb6-463c-87c2-c7d182deed18.png">

Attempt to create a project - switch to the org

<img width="1125" alt="Screen Shot 2022-05-12 at 4 33 01 PM" src="https://user-images.githubusercontent.com/94715080/168198883-d30337f6-a186-4c5b-bc12-2262acd4a201.png">

select the organization - normal without a higher role we will set with the super admin user

<img width="1127" alt="Screen Shot 2022-05-12 at 4 33 08 PM" src="https://user-images.githubusercontent.com/94715080/168198913-476e5984-d559-4049-8f6d-791006e89b4c.png">

verify you don't have rights yet to the organization

<img width="1525" alt="Screen Shot 2022-05-12 at 4 33 21 PM" src="https://user-images.githubusercontent.com/94715080/168198929-4e3d6591-45f3-400c-a863-768244827230.png">

check the onboarding checklist to verify

<img width="1010" alt="Screen Shot 2022-05-12 at 4 33 37 PM" src="https://user-images.githubusercontent.com/94715080/168198942-6ef93771-a32f-4e25-b274-a322d93959a3.png">

Yes, you don't have the rights yet

<img width="1523" alt="Screen Shot 2022-05-12 at 4 33 49 PM" src="https://user-images.githubusercontent.com/94715080/168198949-f4bc1d3c-f343-490a-ad85-a88daba12fc1.png">

Switch tabs to the other super admin user - goto IAM to verify roles

<img width="1429" alt="Screen Shot 2022-05-12 at 4 35 05 PM" src="https://user-images.githubusercontent.com/94715080/168198989-e3e7ec2a-cd0c-404b-898e-8548e959fb68.png">

Add the new user to the role of "Owner" for now - normally use "Folder creator" and "Organization Administrator" for example

<img width="1221" alt="Screen Shot 2022-05-12 at 4 36 23 PM" src="https://user-images.githubusercontent.com/94715080/168198998-0767ccf8-b07f-4ca8-a51f-29d5a38dc469.png">

Verify the user 2 role change

<img width="1396" alt="Screen Shot 2022-05-12 at 4 36 45 PM" src="https://user-images.githubusercontent.com/94715080/168199019-2f660ee4-616b-4862-bd85-a7982c48d0ad.png">

back at user 2 navigate to IAM | cloud identity | verify your new rights

<img width="1113" alt="Screen Shot 2022-05-12 at 4 36 57 PM" src="https://user-images.githubusercontent.com/94715080/168199038-409f725c-c0aa-4325-9a77-06e3982353a9.png">

Notice you now have rights to the organization - good to go

<img width="1125" alt="Screen Shot 2022-05-12 at 4 37 14 PM" src="https://user-images.githubusercontent.com/94715080/168199046-dfdc7981-42d9-49ce-a833-2f26bf15fd84.png">

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
<img width="1197" alt="Screen Shot 2022-05-08 at 22 10 59" src="https://user-images.githubusercontent.com/24765473/167680004-9756a577-c654-4642-9e52-d4f8e97ef2d5.png">


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



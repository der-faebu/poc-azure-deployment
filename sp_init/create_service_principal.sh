#! /bin/bash

# create an initial sp for terraform
# add and grand permissions Application.ReadWrite.All and User.ReadWrite.All

SUBSCRIPTION_ID='ca40ebab-e130-4eb4-aa90-e52a2cc4bc9e'
SP_NAME="terraform_sp" 

echo "creating service principal"
## create initial service principal
CLIENT_SECRET=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID" --name "terraform_sp" --query 'password' -o tsv)

echo "populating env variables"
# save app id, app name an dtenant id into app
read CLIENT_ID SP_NAME TENANT_ID <<< $(az ad sp list --display-name "terraform_sp" --query '[0].{Id:appId, Name:appDisplayName, TenantId:appOwnerOrganizationId}' --output tsv)

APP_READ_WRITE_ALL='1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9=Role'
USER_READ_WRITE_ALL='741f803b-c850-494e-b5df-cde7c675a1ca=Role'
ORG_READ_ALL='498476ce-e0fe-48b0-b801-37ba7e2685c6=Role'
GRAPH_API_GUID='00000003-0000-0000-c000-000000000000'

echo "adding permissions"
az ad app permission add --id ${CLIENT_ID} --api ${GRAPH_API_GUID} --api-permissions ${APP_READ_WRITE_ALL} ${USER_READ_WRITE_ALL} ${ORG_READ_ALL}
az ad app permission grant --id ${CLIENT_ID} --api ${GRAPH_API_GUID} --scope Application.ReadWrite.All User.ReadWrite.All Organization.Read.All

echo "CLIENT_ID: ${CLIENT_ID}"
echo "CLIENT_SECRET: ${CLIENT_SECRET}"
echo "TENANT_ID: ${TENANT_ID}"
echo "SUBSCRIPTION_ID: ${SUBSCRIPTION_ID}"

# az ad sp delete --id ${ARM_CLIENT_ID}
terraform plan -out ../terraform-plan-cust1
terraform apply -auto-approve ../terraform-plan-cust1

az login --service-principal -u ${CLIENT_ID} -p ${CLIENT_SECRET} --tenant ${TENANT_ID}

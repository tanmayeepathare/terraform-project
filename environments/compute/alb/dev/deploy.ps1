param(
    [Parameter(Position = 0)]
    [string]$Action
)

$ErrorActionPreference = "Stop"

#################################################
# APPLY
#################################################

function Apply-Terraform {

    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "Terraform Init"
    Write-Host "==================================" -ForegroundColor Cyan

    terraform init

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform init failed."
    }

    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "Terraform Validate"
    Write-Host "==================================" -ForegroundColor Cyan

    terraform validate

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform validate failed."
    }

    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "Terraform Plan"
    Write-Host "==================================" -ForegroundColor Cyan

    terraform plan -var-file="terraform.tfvars"

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform plan failed."
    }

    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "Terraform Apply"
    Write-Host "==================================" -ForegroundColor Cyan

    terraform apply `
        -var-file="terraform.tfvars" `
        -auto-approve

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform apply failed."
    }
}

#################################################
# DESTROY
#################################################

function Destroy-Terraform {

    Write-Host "==================================" -ForegroundColor Red
    Write-Host "Terraform Destroy"
    Write-Host "==================================" -ForegroundColor Red

    terraform destroy `
        -var-file="terraform.tfvars" `
        -auto-approve

    if ($LASTEXITCODE -ne 0) {
        throw "Terraform destroy failed."
    }
}

#################################################
# MAIN
#################################################

switch ($Action.ToLower()) {

    "apply" {
        Apply-Terraform
    }

    "destroy" {
        Destroy-Terraform
    }

    default {
        Write-Host ""
        Write-Host "Usage:"
        Write-Host ".\deploy.ps1 apply"
        Write-Host ".\deploy.ps1 destroy"
        Write-Host ""
        exit 1
    }
}

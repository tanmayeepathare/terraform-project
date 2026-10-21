
# ============================================================
# MASTER TERRAFORM DEPLOYMENT SCRIPT
# Architecture: VPC + LT + TG + ACM + ALB + ASG
# Usage:
#   .\master.ps1 apply
#   .\master.ps1 destroy
# ============================================================

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("apply", "destroy")]
    [string]$Action
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------

# Root directory containing network and compute modules.
$RootDir = $PSScriptRoot

# Wait 3 minutes after each module.
# Change to 240 for a 4-minute wait.
$WaitSeconds = 180

# ------------------------------------------------------------
# COLORED LOGGING FUNCTIONS
# ------------------------------------------------------------

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Failure {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Wait-ForModule {
    Write-Warning "Waiting 3 minutes for AWS resources and dependencies..."
    Start-Sleep -Seconds $WaitSeconds
}

# ------------------------------------------------------------
# MODULE EXECUTION FUNCTION
# ------------------------------------------------------------

function Invoke-TerraformModule {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ModulePath,

        [Parameter(Mandatory = $true)]
        [string]$Operation
    )

    $FullPath = Join-Path $RootDir $ModulePath
    $DeployScript = Join-Path $FullPath "deploy.ps1"

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan
    Write-Host "$Operation : $ModuleName" -ForegroundColor Magenta
    Write-Host "Directory: $FullPath" -ForegroundColor Gray
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    # Ensure the module and its deploy.ps1 exist.
    if (-not (Test-Path $FullPath -PathType Container)) {
        throw "Module directory not found: $FullPath"
    }

    if (-not (Test-Path $DeployScript -PathType Leaf)) {
        throw "Deployment script not found: $DeployScript"
    }

    # Change to the module directory so relative Terraform
    # paths and local files work as expected.
    Push-Location $FullPath

    try {
        # Run the module's own deployment script.
        & $DeployScript $Operation

        # Check the exit code if the module invokes native
        # executables such as Terraform.
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Module returned exit code $LASTEXITCODE"
        }

        Write-Success "$ModuleName completed successfully."

        # Wait before proceeding to the next module.
        Wait-ForModule
    }
    finally {
        Pop-Location
    }
}

# ------------------------------------------------------------
# DEPLOYMENT MODULE PATHS
# Paths are relative to the environments directory.
# ------------------------------------------------------------

$VPC     = "network\vpc\dev"
$LT      = "compute\lt\dev"
$TG      = "compute\tg\dev"
$ACM     = "compute\acm-alb"
$ALB     = "compute\alb\dev"
$ASG     = "compute\asg\dev"

# ------------------------------------------------------------
# APPLY: CREATE RESOURCES IN DEPENDENCY ORDER
# ------------------------------------------------------------

function Invoke-Apply {

    Write-Host ""
    Write-Host "Applying production-grade AWS architecture" `
        -ForegroundColor Green

    Write-Info "Starting infrastructure deployment..."

    # 1. VPC, subnets, routing and other network prerequisites.
    Write-Info "Creating VPC and networking resources..."
    Invoke-TerraformModule "VPC / Network" $VPC "apply"

    # 2. Create the launch template after network prerequisites.
    Write-Info "Creating Launch Template..."
    Invoke-TerraformModule "Launch Template" $LT "apply"

    # 3. Create the target group before the ALB/ASG.
    Write-Info "Creating Target Group..."
    Invoke-TerraformModule "Target Group" $TG "apply"

    # 4. Create or prepare the ACM certificate.
    Write-Info "Preparing ACM certificate..."
    Invoke-TerraformModule "ACM Certificate" $ACM "apply"

    # 5. Create the ALB and its listeners.
    Write-Info "Creating Application Load Balancer..."
    Invoke-TerraformModule "Application Load Balancer" $ALB "apply"

    # 6. Create the ASG after its dependencies are available.
    Write-Info "Creating Auto Scaling Group..."
    Invoke-TerraformModule "Auto Scaling Group" $ASG "apply"

    Write-Host ""
    Write-Success "ALL MODULES APPLIED SUCCESSFULLY!"
    Write-Host "Architecture deployment completed." `
        -ForegroundColor Green
}

# ------------------------------------------------------------
# DESTROY: REMOVE RESOURCES IN SAFE REVERSE DEPENDENCY ORDER
# ------------------------------------------------------------

function Invoke-Destroy {

    Write-Host ""
    Write-Warning "Starting infrastructure destruction..."
    Write-Warning "Resources will be removed in reverse dependency order."

    # 1. Remove the ASG first so it stops managing instances.
    Invoke-TerraformModule "Auto Scaling Group" $ASG "destroy"

    # 2. Remove the ALB before its attached target group.
    # AWS may reject deletion of a target group still in use.
    Invoke-TerraformModule "Application Load Balancer" $ALB "destroy"

    # 3. Remove the target group after the ALB.
    Invoke-TerraformModule "Target Group" $TG "destroy"

    # 4. Remove the ACM module after the ALB no longer uses it.
    Invoke-TerraformModule "ACM Certificate" $ACM "destroy"

    # 5. Remove the launch template.
    Invoke-TerraformModule "Launch Template" $LT "destroy"

    # 6. Remove the VPC and networking resources last.
    Invoke-TerraformModule "VPC / Network" $VPC "destroy"

    Write-Host ""
    Write-Success "ALL MODULES DESTROYED SUCCESSFULLY!"
    Write-Host "Infrastructure destruction completed." `
        -ForegroundColor Green
}

# ------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------

try {
    switch ($Action) {
        "apply" {
            Invoke-Apply
        }

        "destroy" {
            Invoke-Destroy
        }
    }
}
catch {
    Write-Failure "Execution stopped: $($_.Exception.Message)"
    Write-Warning "Fix the failed module before proceeding."
    exit 1
}

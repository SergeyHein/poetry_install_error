$current_folder = $PSScriptRoot
$user = (Get-ChildItem Env:\USERNAME).Value
$computername = (Get-ChildItem Env:\COMPUTERNAME).Value

new-Item -type Directory -Path "$current_folder\logging" -ErrorAction SilentlyContinue
$stamp = (Get-Date).ToString("yyyy-MM-dd--HH-mm-ss")

$pysysver=python -c "import sys;print(''.join(sys.version.split('.')[0:2]))"

$TestResultsPath="$current_folder\logging\reproduce_github_poetry_issue-${stamp}-py${pysysver}.csv"


$ENV:PATH="$ENV:PATH;$ENV:APPDATA\Python\Scripts"
"Project Name,Step Name,Status" | Out-File  -FilePath "$TestResultsPath"  -Append | Out-Null

function reproduce_github_poetry_issue
{
    
        [CmdletBinding()]
    param (
        [string]$prjname
    )
    cd "$current_folder\$prjname"

    remove-Item -Recurse -Force "$ENV:LOCALAPPDATA\pypoetry"
    del *.lock

    &python --version
    &poetry --version

    poetry lock
    $res="$?"
    Write-Output "$prjname (lock): $res"
    "$prjname,lock,$res" | Out-File  -FilePath "$TestResultsPath"  -Append | Out-Null

    dir *.lock

    &poetry install -vvv 
    $res="$?"
    Write-Output "$prjname (1st attempt): $res"
    "$prjname,1st attempt,$res" | Out-File  -FilePath "$TestResultsPath"  -Append | Out-Null

    dir *.lock

    &poetry install -vvv 
    $res="$?"
    Write-Output "$prjname (2nd attempt): $res"
    "$prjname,2nd attempt,$res" | Out-File  -FilePath "$TestResultsPath"  -Append | Out-Null

    del *.lock
    dir *.lock

    &poetry install -vvv
    $res="$?"
    Write-Output "$prjname (re-install): $res"
    "$prjname,re-install,$res" | Out-File  -FilePath "$TestResultsPath"  -Append | Out-Null

}


function reinstall-poetry {

    remove-Item -Recurse -Force "$ENV:LOCALAPPDATA\pypoetry"
    remove-Item -Recurse -Force "$ENV:APPDATA\pypoetry"
    remove-Item -Recurse -Force "$ENV:APPDATA\Python"

    (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

}

reinstall-poetry
reproduce_github_poetry_issue "prj1"
reproduce_github_poetry_issue "prj2"
reproduce_github_poetry_issue "prj3"


Pause
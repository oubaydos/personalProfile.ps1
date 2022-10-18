# variables 

Set-Variable desktop -Option Constant -Value "your-desktop-path"
function cut {
    param(
        [Parameter(ValueFromPipeline = $True)] [string]$inputobject,
        [string]$delimiter = '\s+',
        [string[]]$field
    )
  
    process {
        if ($null -eq $field) { $inputobject -split $delimiter } else {
        ($inputobject -split $delimiter)[$field] 
        }
    }
}
function isNumeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
function getPid($Port) {
    for ($i = 0; $i -lt 45; $i++) { 
        if (isNumeric $(netstat -ano | findstr 0.0.0.0:$Port | cut -f $i -d ' ' ) ) { 
            return $(netstat -ano | findstr 0.0.0.0:$Port | cut -f $i -d ' ' )
        } 
    }
    return $null
}
function killByPort($Port) {
    TASKKILL /PID $(getPid $Port) /F
}
  

# functions

function cd_desktop {
    cd your-desktop-path
}

function cd_downloads {
    cd your-downloads-path
}


# aliases 

New-Alias cd-desktop cd_desktop
New-Alias cd-downloads cd_downloads
New-Alias touch New-Item
Clear-Host

############## not mine
function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	get-process $name -ErrorAction SilentlyContinue | stop-process
}

function pgrep($name) {
	get-process $name
}
# link
function ln($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
}

set-alias new-link ln
## 
function df {
	get-volume
}
## 

# Like a recursive sed
function edit-recursive($filePattern, $find, $replace) {
	$files = get-childitem . "$filePattern" -rec # -Exclude
	write-output $files
	foreach ($file in $files) {
		(Get-Content $file.PSPath) |
		Foreach-Object { $_ -replace "$find", "$replace" } |
		Set-Content $file.PSPath
	}
}
function grep($regex, $dir) {
	if ( $dir ) {
		get-childitem $dir | select-string $regex
		return
	}
	$input | select-string $regex
}

function grepv($regex) {
	$input | where-object { !$_.Contains($regex) }
}

function show-links($dir){
	get-childitem $dir | where-object {$_.LinkType} | select-object FullName,LinkType,Target
}

function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

function cut(){
	foreach ($part in $input) {
		$line = $part.ToString();
		$MaxLength = [System.Math]::Min(200, $line.Length)
		$line.subString(0, $MaxLength)
	}
}

function Private:file($file) {
	$extension = (Get-Item $file).Extension
	$fileType = (get-itemproperty "Registry::HKEY_Classes_root\$extension")."(default)"
	$description =  (get-itemproperty "Registry::HKEY_Classes_root\$fileType")."(default)"
	write-output $description
}

##
function find-file($name) {
	get-childitem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach-object {
		write-output($PSItem.FullName)
	}
}
set-alias find find-file
set-alias find-name find-file
##
function reboot {
	shutdown /r /t 0
}

##git
function get-git-ignored {
	git ls-files . --ignored --exclude-standard --others
}

function get-git-untracked {
	git ls-files . --exclude-standard --others
}

function fork {
	# Fork requires an absolute path https://github.com/ForkIssues/TrackerWin/issues/416#issuecomment-527067604
	$absolutePath = resolve-path .
	& ${env:LOCALAPPDATA}\Fork\Fork.exe $absolutePath
}
## other
function open($file) {
  invoke-item $file
}
function settings {
  start-process ms-setttings:
}

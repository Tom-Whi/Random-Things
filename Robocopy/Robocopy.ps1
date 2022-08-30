#the script should be saved on the backup drive

#prompt for the backup drive letter 
$destDrive = Read-Host "Enter the backup driver letter (e.g. D, E, F, G) without a colon (:) and press enter"


### VARIABLES 

$computerName = $env:computername
$LogDest = $destDrive + ":\Logs\"
$destinationRoot = $destDrive + ":\Backup\$computerName\" 


### SOURCES

# Nice name which is used for the log and destination folder name, and the value/path which is used for the source (e.g. Temp1='C:\Temp1')
$sources = @{
    Temp1='C:\Temp1'
    Temp='C:\Temp'
}

# for each source in the sources hash
foreach ($source in $sources.GetEnumerator()) {
    
    # destination is the backup drive, plus the source name, e.g. Photos G:\Backup\COMPUTERNAME\Photos\
    $destination = $destinationRoot + "$($source.Name)"

    # copy options
    $robocopyOptions = @('/MIR', '/XA:H', '/W:0', '/R:1', "/LOG+:$LogDest\$(get-date -f yyyy-MM-dd)_$($source.name).log", '/TEE')
        # MIR = Mirror (includes purge if it's been deleted from the source
        # XA = eXclude files with any of the given Attributes set (H = hidden)
        # W = Wait time between retries
        # R = number of Retries on failed copies 
        # LOG+ = output status to LOG file (append to existing log)
        # TEE = output to console window, as well as the log file.

    # commandline to be sent to Robocopy, source, destination + options
    $CmdLine = @($($source.value), $destination) + $robocopyOptions

    # robocopy the files/folder
    & 'robocopy.exe' $CmdLine

}



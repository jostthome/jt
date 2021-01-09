using module JtClass

class JtTimeStop : JtClass {

    hidden [String]$Label
    hidden [DateTime]$TimeBegin
    hidden [DateTime]$TimeEnd
    hidden [timespan]$Duration 

    JtTimeStop() {
        $This.ClassName = "JtTimeStop"

    } 

    [String]GetMessageBegin([DateTime]$Time) {
        [String]$Message = ""
        $Message = -join ("___ Timer ", $Time, " --- ", "(Begin)", " ", " --- ", $This.Label)
        return $Message
    } 

    [String]GetMessageDuration([Timespan]$Timespan) {
        [String]$Message = ""
        $Message = -join ("=== Timer ", " ", $Timespan, " --- ", "(Duration)", " --- ", $This.Label)
        return $Message
    } 

    [String]GetMessageEnd([DateTime]$Time) {
        [String]$Message = ""
        $Message = -join ("___ Timer ", $Time, " --- ", "(End) ", " ", " --- ", $This.Label)
        return $Message
    } 


    Start([String]$Label) {
        $This.Label = $Label
        [DateTime]$D = Get-Date
        $This.TimeBegin = $D
        Write-JtLog -Text ($This.GetMessageBegin($This.TimeBegin))
    } 

    Stop() {
        [DateTime]$D = Get-Date
        $This.TimeEnd = $D

        Write-JtLog -Text ($This.GetMessageEnd($This.TimeEnd))
        $This.Duration = $This.TimeEnd - $This.TimeBegin

        Write-JtLog -Text ($This.GetMessageDuration($This.Duration))
    } 
} 

Function New-JtTimeStop {
    [JtTimeStop]::new()
}


Class JtTimer : JtClass {

    [String]$Name = ""

    $TimeStart
    $TimeEnd
    $TimeDuration

    $BlnStop


    JtTimer([String]$MyName) {
        $This.ClassName = "JtTimer"
        $This.Name = $MyName
        $This.BlnStop = $False
        $This.TimeStart = Get-Date
    }

    Sleep([int32]$Seconds) {
        Start-Sleep -Seconds $Seconds
    }

    Measure() {
        $This.TimeEnd = Get-Date
        $This.BlnStop = $True
        $This.TimeDuration = $This.TimeEnd - $This.TimeStart
    }

    Report() {
        if ($This.BlnStop -eq $False) {
            $Null = $This.Measure()
        }
        Write-Host "=================================="
        Write-Host "Timer   :" $This.Name
        Write-Host "=================================="
        Write-Host "Start   :" $This.TimeStart
        Write-Host "End     :" $This.TimeEnd
        Write-Host "=================================="
        Write-Host "Duration:" $This.TimeDuration
        Write-Host "=================================="
    }
}






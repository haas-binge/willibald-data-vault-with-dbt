
$env:DBT_DATABASE = ''
$env:DBT_PASSWORD = ''
$env:DBT_SNOWFLAKE_ACCOUNT = ''
$env:DBT_USER = ''
$env:DBT_SOURCE_DATABASE = ''

[System.Environment]::SetEnvironmentVariable('DBT_DATABASE',$env:DBT_DATABASE)
[System.Environment]::SetEnvironmentVariable('DBT_PASSWORD', $env:DBT_PASSWORD)
[System.Environment]::SetEnvironmentVariable('DBT_USER', $env:DBT_USER )
[System.Environment]::SetEnvironmentVariable('DBT_SNOWFLAKE_ACCOUNT', $env:DBT_SNOWFLAKE_ACCOUNT)
[System.Environment]::SetEnvironmentVariable('DBT_SOURCE_DATABASE',$env:DBT_SOURCE_DATABASE)

dir env:DBT_*


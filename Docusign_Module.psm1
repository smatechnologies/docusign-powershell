
# Get initial access using authorization code
function docusign_GetAccess($token,$authCode)
{
    $hdr = @{"Authorization"="Basic " + $token}

    $uripost = "https://account-d.docusign.com/oauth/token"
    $body = "grant_type=authorization_code&code=$authCode"

    try
    {
        $access = Invoke-Restmethod -Method POST -Uri $uripost -Headers $hdr -Body $body -ContentType "application/x-www-form-urlencoded"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $access
}

# Get a new access/refresh token
function docusign_RefreshAccess($token,$refreshToken)
{
    $hdr = @{"Authorization"="Basic " + $token}

    $uripost = "https://account-d.docusign.com/oauth/token"
    $body = "grant_type=refresh_token&refresh_token=$refreshToken"

    try
    {
        $access = Invoke-Restmethod -Method POST -Uri $uripost -Headers $hdr -Body $body -ContentType "application/x-www-form-urlencoded"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $access
}


# Used for getting some initial information for future calls
function docusign_GetUserInfo($access_token)
{
    $hdr = @{ "Authorization" = "Bearer " + $access_token }

    $uriget = "https://account-d.docusign.com/oauth/userinfo"

    try
    {
        $user = Invoke-Restmethod -Method GET -Uri $uriget -Headers $hdr -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $user
}


function docusign_GetBrands($url,$access_token,$accountID)
{
    $hdr = @{ "Authorization" = "Bearer " + $access_token }

    $uriget = "$url/v2/accounts/$accountID/brands"

    try
    {
        $brands = Invoke-Restmethod -Method GET -Uri $uriget -Headers $hdr -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $brands
}

function docusign_GetTemplates($url,$access_token,$accountID)
{
    $hdr = @{ "Authorization" = "Bearer " + $access_token }

    $uriget = "$url/v2/accounts/$accountID/templates"

    try
    {
        $templates = Invoke-Restmethod -Method GET -Uri $uriget -Headers $hdr -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $templates
}


function docusign_GetEnvelopeStatus($url,$access_token,$accountID)
{
    $hdr = @{ "Authorization" = "Bearer " + $access_token }

    $from_date = Get-Date -Format "yyyy-MM-dd" -Date ((Get-Date).AddDays(-35))
    $uriget = "$url/v2/accounts/$accountID/envelopes/status?from_date=" + $from_date

    try
    {
        $envelopes = Invoke-Restmethod -Method GET -Uri $uriget -Headers $hdr -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $envelopes
}


function docusign_GetEnvelope($url,$access_token,$accountID,$envelopeID)
{
    $hdr = @{ "Authorization" = "Bearer " + $access_token }

    $uriget = "$url/v2/accounts/$accountID/envelopes/" + $envelopeID

    try
    {
        $envelope = Invoke-Restmethod -Method GET -Uri $uriget -Headers $hdr -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $envelope
}


function docusign_SendEnvelope($url,$access_token,$accountID,$status,$emailSubject,$documents,$signers)
{
    $hdr = @{ "Authorization" = "Bearer " + $access_token }

    $uripost = "$url/v2/accounts/$accountID/envelopes"

    $body = @{ "status" = "$status"; 
               "emailSubject" = "$emailSubject";
               "documents" = $documents;
               "recipients" = @{
                      "signers" = $signers }
             }

    try
    {
        $envelope = Invoke-Restmethod -Method POST -Uri $uripost -Body ($body | ConvertTo-Json -Depth 7) -Headers $hdr -ContentType "application/json"
    }
    catch [Exception]
    {
        write-host $_
        write-host $_.Exception.Message
        Exit 103
    }

    return $envelope
}
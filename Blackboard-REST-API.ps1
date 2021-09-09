# Config
$bb_appkey = ""
$bb_secret = ""
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("8d75ff2c-50c1-4e9a-989d-ed8a61ac9193:qIbxs7RNZcZ4NHawC2uLfUoy03Jk2w9b")))
$base64AuthInfo
$baseURL = "https://54.236.28.21"

# Trust HTTPS
# from https://stackoverflow.com/questions/11696944/powershell-v3-invoke-webrequest-https-error
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
try {
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
} catch {}


# HTTP Access Token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("grant_type", "client_credentials")
$headers.Add("Content-Type", "application/x-www-form-urlencoded")
$headers.Add("Authorization", "Basic $base64AuthInfo")
$headers.Add("Host", "localhost")
$headers.Add("User-Agent", "powershell")
$headers.Add("Accept", "*/*")
$headers.Add("Accept-Encoding", "powershell")
$body = "grant_type=client_credentials"
$response = Invoke-RestMethod "$baseURL/learn/api/public/v1/oauth2/token" -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json
$access_token = $response.access_token
Write-Host $access_token -Fore "Yellow"


# HTTP Query Courses
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $access_token")
$response = Invoke-RestMethod "$baseURL/learn/api/public/v1/courses" -Headers $headers
$response | ConvertTo-Json

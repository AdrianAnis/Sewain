$path = "d:\TELKOM UNIVERSITY\TUGAS KULIAH\SEMESTER 4\PBO\Tubes\Sewain\web\pages\owner\edit_property.jsp"
$content = [System.IO.File]::ReadAllText($path)

# Find the <script> block starting with "let selectedGalleryFiles = [];" and ending with "getResolvedUrl(path)"
$pattern = '<!-- SCRIPTS -->\s*<script>[\s\S]*?let selectedGalleryFiles = \[\s*\];[\s\S]*?getResolvedUrl[\s\S]*?<\/script>'

$replacement = '<!-- SCRIPTS -->
    <script>
        window.originalPhotos = "<%= property.getPhotos() != null ? property.getPhotos() : `"`"`" %>";
        window.originalFacilities = "<%= property.getFacilities() != null ? property.getFacilities() : `"`"`" %>";
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/owner/edit_property.js"></script>'

# We use double quotes escape or replacement that handles standard quotes
$replacement = $replacement.Replace('`"`"`"', '""')

if ($content -match $pattern) {
    $newContent = $content -replace $pattern, $replacement
    [System.IO.File]::WriteAllText($path, $newContent)
    Write-Output "Successfully replaced inline script in edit_property.jsp"
} else {
    Write-Output "Pattern not found in edit_property.jsp"
}

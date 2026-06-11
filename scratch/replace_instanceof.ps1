$path = "d:\TELKOM UNIVERSITY\TUGAS KULIAH\SEMESTER 4\PBO\Tubes\Sewain\web\pages\tenant\detail.jsp"
$content = [System.IO.File]::ReadAllText($path)

# Regex to match the scriptlet containing the instanceof checks
$pattern = 'String gender = "";\s*String roomType = "";\s*int jumlahKamar = 0;\s*double luasTanah = 0;\s*int durasiMinimum = 0;\s*int lantai = 0;\s*String nomorUnit = "";\s*String tipeUnit = "";\s*if \(p instanceof Kost\) \{[\s\S]*?\}'

$replacement = 'String gender = p.getGender();
                String roomType = p.getRoomType();
                int jumlahKamar = p.getJumlahKamar();
                double luasTanah = p.getLuasTanah();
                int durasiMinimum = p.getDurasiMinimum();
                int lantai = p.getLantai();
                String nomorUnit = p.getNomorUnit();
                String tipeUnit = p.getTipeUnit();'

if ($content -match $pattern) {
    $newContent = $content -replace $pattern, $replacement
    [System.IO.File]::WriteAllText($path, $newContent)
    Write-Output "Successfully replaced instanceof cascade in detail.jsp"
} else {
    Write-Output "Pattern not found in detail.jsp"
}

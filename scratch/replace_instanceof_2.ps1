$path = "d:\TELKOM UNIVERSITY\TUGAS KULIAH\SEMESTER 4\PBO\Tubes\Sewain\web\pages\tenant\detail.jsp"
$content = [System.IO.File]::ReadAllText($path)

$pattern = 'String gender = p\.getGender\(\);[\s\S]*?else if \(p instanceof Rumah\) \{[\s\S]*?\}\s*%>'
$replacement = "String gender = p.getGender();
                String roomType = p.getRoomType();
                int jumlahKamar = p.getJumlahKamar();
                double luasTanah = p.getLuasTanah();
                int durasiMinimum = p.getDurasiMinimum();
                int lantai = p.getLantai();
                String nomorUnit = p.getNomorUnit();
                String tipeUnit = p.getTipeUnit();
            %>"

if ($content -match $pattern) {
    $newContent = $content -replace $pattern, $replacement
    [System.IO.File]::WriteAllText($path, $newContent)
    Write-Output "Successfully fixed instanceof cascade in detail.jsp"
} else {
    Write-Output "Pattern not found in detail.jsp"
}

# auto_push.ps1

# ============================
# 配置部分：請根據實際情況修改以下變量
# ============================

# 本地倉庫路徑
$RepoPath = "C:\AutoGit"

# GitHub 用戶名
$UserName = "lcw900914"

# GitHub 倉庫的 HTTPS URL
$RepoURL = "https://github.com/lcw900914/autoSave.git"

# 要操作的分支名稱（通常是 master 或 main）
$Branch = "master"  # 或 "main" 根據你的倉庫設置

# 日誌檔案路徑
$LogFile = Join-Path $RepoPath "auto_push.log"

# 提交訊息
$CommitMessage = "Auto-commit on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# ============================
# 腳本邏輯
# ============================

# 開始日誌
Add-Content -Path $LogFile -Value "---- Start Push at $(Get-Date) ----"

# 記錄參數及其長度
Add-Content -Path $LogFile -Value "==== Param Check at $(Get-Date) ===="
Add-Content -Path $LogFile -Value "RepoPath = $RepoPath (Length: $($RepoPath.Length))"
Add-Content -Path $LogFile -Value "UserName = $UserName (Length: $($UserName.Length))"
Add-Content -Path $LogFile -Value "RepoURL  = $RepoURL (Length: $($RepoURL.Length))"
Add-Content -Path $LogFile -Value "Branch   = $Branch (Length: $($Branch.Length))"
Add-Content -Path $LogFile -Value "==================================="

# 切換到倉庫目錄
Set-Location -Path $RepoPath

# 確保遠端 URL 設置為 HTTPS
git remote set-url origin $RepoURL

# 添加所有更改
git add .

# 提交更改（如果有）
$commitResult = git commit -m "$CommitMessage"

# 檢查是否有更改需要提交
if ($commitResult -match "nothing to commit") {
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - No changes to commit."
} else {
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Committed changes."
}

# 拉取最新更改（帶 rebase）
try {
    git pull origin $Branch --rebase
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Pulled latest changes."
}
catch {
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error pulling changes: $_"
    exit 1
}

# 推送更改到遠端倉庫
try {
    git push origin $Branch
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Pushed changes successfully."
}
catch {
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error pushing changes: $_"
}

# 結束日誌
Add-Content -Path $LogFile -Value "---- End Push ----`n"

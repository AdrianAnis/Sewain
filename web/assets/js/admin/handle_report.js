document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("report-search");
    const statusFilter = document.getElementById("status-filter");

    if (searchInput) searchInput.addEventListener("input", filterReports);
    if (statusFilter) statusFilter.addEventListener("change", filterReports);

    updateReportCount();
});

// 1. Client-Side Filters
function filterReports() {
    const query = document.getElementById("report-search").value.toLowerCase().trim();
    const status = document.getElementById("status-filter").value.toLowerCase();

    const rows = document.querySelectorAll(".report-row");
    let matchCount = 0;

    rows.forEach(row => {
        const propName = row.getAttribute("data-prop-name").toLowerCase();
        const tenantName = row.getAttribute("data-tenant-name").toLowerCase();
        const issue = row.getAttribute("data-issue").toLowerCase();
        const desc = row.getAttribute("data-desc").toLowerCase();
        const rowStatus = row.getAttribute("data-status").toLowerCase();

        const matchesQuery = propName.includes(query) || tenantName.includes(query) || issue.includes(query) || desc.includes(query);
        const matchesStatus = (status === "all") || (rowStatus === status);

        if (matchesQuery && matchesStatus) {
            row.style.display = "";
            matchCount++;
        } else {
            row.style.display = "none";
        }
    });

    updateReportCount(matchCount);
}

function updateReportCount(count = null) {
    const badge = document.getElementById("report-count-badge");
    if (!badge) return;

    if (count === null) {
        count = document.querySelectorAll(".report-row").length;
    }
    badge.textContent = `${count} Laporan`;
}

// 2. Resolve Report (Tandai Selesai) via AJAX
function resolveReport(reportId) {
    if (!confirm("Apakah Anda yakin ingin menandai laporan ini sebagai SELESAI?")) return;

    showLoader();

    const params = new URLSearchParams();
    params.append("action", "resolveReport");
    params.append("reportId", reportId);

    fetch(`${window.contextPath}/admin/reports`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideLoader();
        if (data.success) {
            updateReportRowStatus(reportId, "Resolved");
        } else {
            alert(data.message || "Gagal menyelesaikan laporan.");
        }
    })
    .catch(error => {
        hideLoader();
        console.error("Error resolving report:", error);
        alert("Terjadi kesalahan koneksi server.");
    });
}

function updateReportRowStatus(reportId, newStatus) {
    const row = document.querySelector(`.report-row[data-id="${reportId}"]`);
    if (!row) return;

    row.setAttribute("data-status", newStatus);
    
    const statusBadge = row.querySelector(".status-badge");
    if (statusBadge) {
        statusBadge.textContent = newStatus;
        statusBadge.className = `status-badge status-${newStatus.toLowerCase()}`;
    }

    const actionCell = row.querySelector(".action-buttons");
    if (actionCell) {
        actionCell.innerHTML = `<span class="text-success text-xs font-bold"><i class="fa-solid fa-circle-check"></i> Selesai</span>`;
    }

    filterReports();
}

// 3. Flag Property via Modal
function openFlagModal(propertyId, propertyName) {
    document.getElementById("flag-property-id").value = propertyId;
    document.getElementById("flag-prop-display-name").textContent = propertyName;
    document.getElementById("flag-reason").value = "";
    document.getElementById("flag-modal").style.display = "flex";
}

function closeFlagModal() {
    document.getElementById("flag-modal").style.display = "none";
}

function executeFlag(event) {
    event.preventDefault();

    const propertyId = document.getElementById("flag-property-id").value;
    const reason = document.getElementById("flag-reason").value.trim();

    closeFlagModal();
    showLoader();

    const params = new URLSearchParams();
    params.append("action", "flagProperty");
    params.append("propertyId", propertyId);
    params.append("reason", reason);

    fetch(`${window.contextPath}/admin/reports`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideLoader();
        if (data.success) {
            alert("Properti berhasil ditandai (flagged) dan ditangguhkan.");
            // Reload page to reflect updated property status across all related reports
            window.location.reload();
        } else {
            alert(data.message || "Gagal menandai properti.");
        }
    })
    .catch(error => {
        hideLoader();
        console.error("Error flagging property:", error);
        alert("Terjadi kesalahan koneksi server.");
    });
}

function showLoader() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideLoader() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}

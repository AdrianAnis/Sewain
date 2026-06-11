document.addEventListener("DOMContentLoaded", () => {
    // 1. Resolve Cover Images for all cards
    resolveCardImages();
});

function resolveCardImages() {
    const images = document.querySelectorAll(".property-img-preview");
    images.forEach(img => {
        const photoStr = img.getAttribute("data-photos");
        // resolvePropertyImage is imported from property-utils.js
        if (typeof resolvePropertyImage === "function") {
            img.src = resolvePropertyImage(photoStr);
        } else {
            img.src = `${window.contextPath}/assets/images/default-property.jpg`;
        }
    });
}

// 2. Approve Property Action via AJAX POST
function approveProperty(propertyId) {
    if (!confirm("Apakah Anda yakin ingin menyetujui iklan properti ini?")) return;

    showSpinner();

    const params = new URLSearchParams();
    params.append("action", "approve");
    params.append("propertyId", propertyId);

    fetch(`${window.contextPath}/admin/verify`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideSpinner();
        if (data.success) {
            removeCardFromUI(propertyId);
        } else {
            alert(data.message || "Gagal menyetujui properti.");
        }
    })
    .catch(error => {
        hideSpinner();
        console.error("Error approving property:", error);
        alert("Terjadi kesalahan koneksi server.");
    });
}

// 3. Reject Property Action via Modal
function openRejectModal(propertyId) {
    document.getElementById("reject-property-id").value = propertyId;
    document.getElementById("reject-reason").value = "";
    document.getElementById("reject-modal").style.display = "flex";
}

function closeRejectModal() {
    document.getElementById("reject-modal").style.display = "none";
}

function executeReject(event) {
    event.preventDefault();

    const propertyId = document.getElementById("reject-property-id").value;
    const reason = document.getElementById("reject-reason").value.trim();

    closeRejectModal();
    showSpinner();

    const params = new URLSearchParams();
    params.append("action", "reject");
    params.append("propertyId", propertyId);
    params.append("reason", reason);

    fetch(`${window.contextPath}/admin/verify`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideSpinner();
        if (data.success) {
            removeCardFromUI(propertyId);
        } else {
            alert(data.message || "Gagal menolak properti.");
        }
    })
    .catch(error => {
        hideSpinner();
        console.error("Error rejecting property:", error);
        alert("Terjadi kesalahan koneksi server.");
    });
}

// 4. UI Helper: Remove Card & Check Empty State
function removeCardFromUI(propertyId) {
    const card = document.querySelector(`.property-card[data-id="${propertyId}"]`);
    if (!card) return;

    // Smooth fade out & slide up animation
    card.style.transition = "all 0.4s ease";
    card.style.opacity = "0";
    card.style.transform = "scale(0.9) translateY(-20px)";

    setTimeout(() => {
        card.remove();
        
        // Update Counter
        updatePendingCounter();
    }, 400);
}

function updatePendingCounter() {
    const container = document.getElementById("properties-container");
    const counterBadge = document.getElementById("pending-count");
    
    const remainingCards = container.querySelectorAll(".property-card").length;
    
    if (counterBadge) {
        counterBadge.textContent = `${remainingCards} Pengajuan`;
    }

    if (remainingCards === 0) {
        container.innerHTML = `
            <div class="no-pending-state">
                <i class="fa-solid fa-circle-check success-icon"></i>
                <h3>Semua Bersih!</h3>
                <p>Tidak ada pengajuan properti baru yang menunggu verifikasi saat ini.</p>
            </div>
        `;
    }
}

function showSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}

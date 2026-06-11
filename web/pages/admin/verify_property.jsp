<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="model.User, model.Property" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <% // Ensure user session exists and role is admin User currentUser=(User)
                session.getAttribute("userSession"); if (currentUser==null ||
                !"admin".equalsIgnoreCase(currentUser.getRole())) { response.sendRedirect(request.getContextPath()
                + "/pages/auth/login.jsp" ); return; } // Check if request attributes from servlet exist. If not,
                redirect to servlet. if (request.getAttribute("pendingProperties")==null) {
                response.sendRedirect(request.getContextPath() + "/admin/verify" ); return; } %>
                <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Verifikasi Properti - SewaIn Admin</title>
                    <!-- Fonts -->
                    <link rel="preconnect" href="https://fonts.googleapis.com" />
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                        rel="stylesheet" />

                    <!-- CSS Stylesheets -->
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/admin/verify_property.css" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

                    <script>
                        window.contextPath = "${pageContext.request.contextPath}";
                    </script>
                </head>

                <body>
                    <!-- AJAX Loader Spinner -->
                    <div id="ajax-loader" class="loader-overlay" style="display: none;">
                        <div class="loader-spinner"></div>
                    </div>

                    <!-- MAIN CONTAINER -->
                    <div class="admin-container">

                        <!-- SIDEBAR -->
                        <aside class="admin-sidebar">
                            <div class="sidebar-header">
                                <div class="logo">
                                    <i class="fa-solid fa-leaf logo-icon"></i>
                                    <span>Sewa<span class="logo-highlight">In</span> Admin</span>
                                </div>
                            </div>

                            <nav class="sidebar-menu">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item">
                                    <i class="fa-solid fa-gauge"></i>
                                    <span>Dashboard</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="menu-item">
                                    <i class="fa-solid fa-users"></i>
                                    <span>Kelola User</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/verify" class="menu-item active">
                                    <i class="fa-solid fa-shield-halved"></i>
                                    <span>Verifikasi Properti</span>
                                    <c:if test="${not empty pendingProperties}">
                                        <span class="badge badge-verify">${pendingProperties.size()}</span>
                                    </c:if>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item">
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                    <span>Kelola Laporan</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/flagged" class="menu-item">
                                    <i class="fa-solid fa-flag"></i>
                                    <span>Properti Bermasalah</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/activity" class="menu-item">
                                    <i class="fa-solid fa-clock-rotate-left"></i>
                                    <span>Log Aktivitas</span>
                                </a>
                            </nav>

                            <div class="sidebar-footer">
                                <div class="admin-profile">
                                    <div class="profile-avatar">
                                        <i class="fa-solid fa-user-shield"></i>
                                    </div>
                                    <div class="profile-info">
                                        <span class="profile-name">
                                            <%= currentUser.getName() %>
                                        </span>
                                        <span class="profile-role">Senior Administrator</span>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                                    <i class="fa-solid fa-right-from-bracket"></i>
                                    <span>Keluar</span>
                                </a>
                            </div>
                        </aside>

                        <!-- MAIN CONTENT -->
                        <main class="admin-main">
                            <!-- HEADER -->
                            <header class="main-header">
                                <div class="header-title-container">
                                    <h1 class="main-title">Verifikasi Properti</h1>
                                    <ul class="breadcrumb">
                                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                                        <li><i class="fa-solid fa-chevron-right separator"></i></li>
                                        <li class="active">Verifikasi Properti</li>
                                    </ul>
                                </div>
                            </header>

                            <!-- PENDING PROPERTIES GRID/CARDS -->
                            <section class="cards-section">
                                <div class="section-header">
                                    <h2 class="section-title">Properti Menunggu Persetujuan</h2>
                                    <span class="badge badge-verify" id="pending-count">${not empty pendingProperties ?
                                        pendingProperties.size() : 0} Pengajuan</span>
                                </div>

                                <div class="properties-grid" id="properties-container">
                                    <c:forEach var="p" items="${pendingProperties}">
                                        <div class="property-card" data-id="${p.propertyId}" data-name="${p.name}">
                                            <!-- PROPERTY COVER IMAGE -->
                                            <div class="property-image-wrapper">
                                                <img src="" alt="${p.name}" class="property-img-preview"
                                                    data-photos="${p.photos}">
                                                <span class="property-type-tag">${p.propertyType}</span>
                                            </div>

                                            <!-- PROPERTY DETAILS -->
                                            <div class="property-info-wrapper">
                                                <h3 class="property-title">${p.name}</h3>
                                                <p class="property-owner"><i class="fa-solid fa-user-tie"></i> Owner:
                                                    <strong>${p.ownerName}</strong></p>
                                                <p class="property-location"><i class="fa-solid fa-location-dot"></i>
                                                    ${p.location}</p>

                                                <div class="property-specs">
                                                    <span>Rp
                                                        <c:formatNumber value="${p.price}" pattern="#,###" /> / bln
                                                    </span>
                                                </div>

                                                <div class="property-desc-preview">
                                                    <p>${p.description}</p>
                                                </div>
                                            </div>

                                            <!-- ACTION BUTTONS -->
                                            <div class="property-actions">
                                                <button class="btn-verify btn-approve"
                                                    onclick="approveProperty(${p.propertyId})" title="Setujui Properti">
                                                    <i class="fa-solid fa-check"></i> Setujui
                                                </button>
                                                <button class="btn-verify btn-reject"
                                                    onclick="openRejectModal(${p.propertyId})" title="Tolak Properti">
                                                    <i class="fa-solid fa-xmark"></i> Tolak
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty pendingProperties}">
                                        <div class="no-pending-state">
                                            <i class="fa-solid fa-circle-check success-icon"></i>
                                            <h3>Semua Bersih!</h3>
                                            <p>Tidak ada pengajuan properti baru yang menunggu verifikasi saat ini.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </section>
                        </main>
                    </div>

                    <!-- REJECT MODAL WITH REASON INPUT -->
                    <div id="reject-modal" class="modal-overlay" style="display: none;">
                        <div class="modal-card">
                            <div class="modal-header header-warning">
                                <h3>Tolak Pengajuan Properti</h3>
                                <button class="modal-close" onclick="closeRejectModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <form id="reject-form" onsubmit="executeReject(event)">
                                    <input type="hidden" id="reject-property-id">
                                    <p class="form-instruction">Harap berikan alasan penolakan properti secara rinci
                                        agar owner dapat merevisi data mereka.</p>
                                    <div class="form-group">
                                        <label for="reject-reason">Alasan Penolakan:</label>
                                        <textarea id="reject-reason" rows="4" required
                                            placeholder="Contoh: Deskripsi kurang jelas atau gambar tidak relevan..."></textarea>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button class="btn-secondary" onclick="closeRejectModal()">Batal</button>
                                <button type="submit" form="reject-form" class="btn-primary btn-danger">Ya, Tolak
                                    Pengajuan</button>
                            </div>
                        </div>
                    </div>

                    <!-- JS Scripts -->
                    <script src="${pageContext.request.contextPath}/assets/js/property-utils.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/admin/verify_property.js"></script>
                </body>

                </html>
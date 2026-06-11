<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, model.Report" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
    // Ensure user session exists and role is admin 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    // Check if request attributes from servlet exist. If not, redirect to servlet.
    if (request.getAttribute("reports") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/reports");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Laporan - SewaIn Admin</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/handle_report.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
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
                <a href="${pageContext.request.contextPath}/admin/verify" class="menu-item">
                    <i class="fa-solid fa-shield-halved"></i>
                    <span>Verifikasi Properti</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item active">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>Kelola Laporan</span>
                    <c:if test="${not empty reports}">
                        <!-- Will display count dynamically -->
                    </c:if>
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
                        <span class="profile-name"><%= currentUser.getName() %></span>
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
                    <h1 class="main-title">Kelola Laporan</h1>
                    <ul class="breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                        <li><i class="fa-solid fa-chevron-right separator"></i></li>
                        <li class="active">Kelola Laporan</li>
                    </ul>
                </div>
            </header>

            <!-- FILTER BAR -->
            <section class="filter-card">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass search-icon"></i>
                    <input type="text" id="report-search" placeholder="Cari nama properti, pelapor, atau jenis pelanggaran...">
                </div>
                
                <div class="filter-options">
                    <div class="filter-group">
                        <label for="status-filter"><i class="fa-solid fa-filter"></i> Status:</label>
                        <select id="status-filter">
                            <option value="all">Semua Status</option>
                            <option value="pending">Pending</option>
                            <option value="resolved">Selesai (Resolved)</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- REPORTS TABLE -->
            <section class="table-card">
                <div class="card-header">
                    <h3 class="table-card-title">Daftar Laporan Pelanggaran</h3>
                    <span id="report-count-badge" class="table-subtitle">Memuat...</span>
                </div>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width: 15%;">Tanggal</th>
                                <th style="width: 20%;">Properti</th>
                                <th style="width: 15%;">Pelapor</th>
                                <th style="width: 15%;">Pelanggaran</th>
                                <th style="width: 20%;">Keterangan</th>
                                <th style="width: 15%;">Status</th>
                                <th class="text-center" style="width: 20%;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody id="report-table-body">
                            <c:forEach var="r" items="${reports}">
                                <tr class="report-row" 
                                    data-id="${r.reportId}" 
                                    data-prop-id="${r.propertyId}" 
                                    data-prop-name="${r.propertyName}"
                                    data-tenant-name="${r.tenantName}"
                                    data-issue="${r.issueType}"
                                    data-desc="${r.description}"
                                    data-status="${r.status}">
                                    <td>
                                        <fmt:formatDate value="${r.reportDate}" pattern="dd MMM yyyy"/>
                                    </td>
                                    <td class="font-bold">${r.propertyName}</td>
                                    <td>${r.tenantName}</td>
                                    <td>
                                        <span class="issue-badge">${r.issueType}</span>
                                    </td>
                                    <td class="text-muted text-sm desc-cell" title="${r.description}">${r.description}</td>
                                    <td>
                                        <span class="status-badge status-${r.status.toLowerCase()}" style="display: inline-flex; align-items: center; gap: 6px;">
                                            <c:choose>
                                                <c:when test="${r.status.equalsIgnoreCase('resolved')}">
                                                    <i class="fa-solid fa-circle-check"></i>
                                                </c:when>
                                                <c:when test="${r.status.equalsIgnoreCase('investigating')}">
                                                    <i class="fa-solid fa-magnifying-glass"></i>
                                                </c:when>
                                                <c:when test="${r.status.equalsIgnoreCase('rejected')}">
                                                    <i class="fa-solid fa-circle-xmark"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-clock"></i>
                                                </c:otherwise>
                                            </c:choose>
                                            ${r.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <c:if test="${r.status.equalsIgnoreCase('pending')}">
                                                <button class="btn-action btn-resolve" onclick="resolveReport(${r.reportId})" title="Tandai Selesai">
                                                    <i class="fa-solid fa-square-check"></i>
                                                </button>
                                                <button class="btn-action btn-flag" onclick="openFlagModal(${r.propertyId}, '${r.propertyName}')" title="Flag Properti">
                                                    <i class="fa-solid fa-flag"></i>
                                                </button>
                                            </c:if>
                                            <c:if test="${r.status.equalsIgnoreCase('resolved')}">
                                                <span class="text-success text-xs font-bold"><i class="fa-solid fa-circle-check"></i> Selesai</span>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty reports}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-8">
                                        <i class="fa-regular fa-folder-open text-4xl mb-2 block"></i>
                                        Tidak ada laporan pelanggaran yang masuk.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- FLAG PROPERTY MODAL -->
    <div id="flag-modal" class="modal-overlay" style="display: none;">
        <div class="modal-card">
            <div class="modal-header header-warning">
                <h3>Flag Iklan Properti</h3>
                <button class="modal-close" onclick="closeFlagModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="flag-form" onsubmit="executeFlag(event)">
                    <input type="hidden" id="flag-property-id">
                    <p class="form-instruction">Menandai properti <strong><span id="flag-prop-display-name"></span></strong> akan menangguhkan iklan ini sehingga tidak terlihat di hasil pencarian tenant. Harap masukkan alasan pemberian flag.</p>
                    <div class="form-group">
                        <label for="flag-reason">Alasan Pemberian Flag:</label>
                        <textarea id="flag-reason" rows="4" required placeholder="Contoh: Iklan palsu, gambar menipu, pemilik tidak dapat dihubungi..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeFlagModal()">Batal</button>
                <button type="submit" form="flag-form" class="btn-primary btn-danger">Tandai (Flag)</button>
            </div>
        </div>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/admin/handle_report.js"></script>
</body>
</html>

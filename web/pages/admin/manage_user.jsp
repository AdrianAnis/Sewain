<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
    // Ensure user session exists and role is admin 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    // Check if request attributes from servlet exist. If not, redirect to servlet.
    if (request.getAttribute("users") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola User - SewaIn Admin</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/manage_user.css" />
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
                <a href="${pageContext.request.contextPath}/admin/users" class="menu-item active">
                    <i class="fa-solid fa-users"></i>
                    <span>Kelola User</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/verify" class="menu-item">
                    <i class="fa-solid fa-shield-halved"></i>
                    <span>Verifikasi Properti</span>
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
                    <h1 class="main-title">Kelola User</h1>
                    <ul class="breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                        <li><i class="fa-solid fa-chevron-right separator"></i></li>
                        <li class="active">Kelola User</li>
                    </ul>
                </div>
            </header>

            <!-- FILTER BAR -->
            <section class="filter-card">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass search-icon"></i>
                    <input type="text" id="search-input" placeholder="Cari nama, email, atau no. telepon...">
                </div>
                
                <div class="filter-options">
                    <div class="filter-group">
                        <label for="role-filter"><i class="fa-solid fa-filter"></i> Role:</label>
                        <select id="role-filter">
                            <option value="all">Semua Role</option>
                            <option value="tenant">Tenant (Penyewa)</option>
                            <option value="owner">Owner (Pemilik)</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label for="status-filter"><i class="fa-solid fa-circle-info"></i> Status:</label>
                        <select id="status-filter">
                            <option value="all">Semua Status</option>
                            <option value="active">Aktif</option>
                            <option value="suspended">Ditangguhkan</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- USERS TABLE CARD -->
            <section class="table-card">
                <div class="card-header">
                    <h3 class="table-card-title">Daftar Pengguna</h3>
                    <span id="user-count-badge" class="table-subtitle">Memuat data...</span>
                </div>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Nama</th>
                                <th>Email</th>
                                <th>No. Telepon</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody id="user-table-body">
                            <c:forEach var="u" items="${users}">
                                <tr class="user-row" 
                                    data-id="${u.userId}" 
                                    data-name="${u.name}" 
                                    data-email="${u.email}" 
                                    data-phone="${u.phone != null ? u.phone : '-'}" 
                                    data-role="${u.role}" 
                                    data-status="${u.status != null ? u.status : 'Active'}">
                                    <td class="font-bold">${u.name}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone != null ? u.phone : '-'}</td>
                                    <td>
                                        <span class="role-badge role-${u.role.toLowerCase()}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${u.status != null ? u.status.toLowerCase() : 'active'}">
                                            ${u.status != null ? u.status : 'Active'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-action btn-detail" onclick="showUserDetail('${u.userId}')" title="Detail Pengguna">
                                                <i class="fa-solid fa-eye"></i>
                                            </button>
                                            <c:if test="${!u.role.equalsIgnoreCase('admin')}">
                                                <c:choose>
                                                    <c:when var="isSuspended" test="${u.status.equalsIgnoreCase('suspended')}">
                                                        <button class="btn-action btn-activate" onclick="confirmToggleStatus('${u.userId}', 'Active')" title="Aktifkan Akun">
                                                            <i class="fa-solid fa-user-check"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn-action btn-suspend" onclick="confirmToggleStatus('${u.userId}', 'Suspended')" title="Tangguhkan Akun">
                                                            <i class="fa-solid fa-user-minus"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-8">
                                        <i class="fa-regular fa-folder-open text-4xl mb-2 block"></i>
                                        Tidak ada data pengguna yang ditemukan.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- DETAIL USER MODAL -->
    <div id="detail-modal" class="modal-overlay" style="display: none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Detail Profil Pengguna</h3>
                <button class="modal-close" onclick="closeDetailModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="detail-avatar-container">
                    <div class="detail-avatar"><i class="fa-solid fa-user"></i></div>
                    <h4 id="detail-name">Nama Lengkap</h4>
                    <span id="detail-role-badge" class="role-badge">Tenant</span>
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">User ID</span>
                        <span id="detail-id" class="detail-val">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Email</span>
                        <span id="detail-email" class="detail-val">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">No. Telepon</span>
                        <span id="detail-phone" class="detail-val">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Status Akun</span>
                        <span id="detail-status" class="status-badge">Aktif</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeDetailModal()">Tutup</button>
            </div>
        </div>
    </div>

    <!-- CONFIRMATION MODAL (GENERIC FOR DESTRUCTIVE ACTIONS) -->
    <div id="confirm-modal" class="modal-overlay" style="display: none;">
        <div class="modal-card modal-confirm">
            <div class="modal-header header-warning">
                <h3 id="confirm-title">Konfirmasi Aksi</h3>
                <button class="modal-close" onclick="closeConfirmModal()">&times;</button>
            </div>
            <div class="modal-body">
                <p id="confirm-message">Apakah Anda yakin ingin melakukan aksi ini?</p>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeConfirmModal()">Batal</button>
                <button id="confirm-submit-btn" class="btn-primary btn-danger">Ya, Lanjutkan</button>
            </div>
        </div>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/admin/manage_user.js"></script>
</body>
</html>

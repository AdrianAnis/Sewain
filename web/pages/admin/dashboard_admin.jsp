<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<% 
    // Ensure user session exists and role is admin 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    // Check if request attributes from servlet exist. If not, redirect to servlet.
    if (request.getAttribute("totalUsers") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SewaIn</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css" />
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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item active">
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
                    <% if (request.getAttribute("pendingVerificationsCount") != null && (int)request.getAttribute("pendingVerificationsCount") > 0) { %>
                        <span class="badge badge-verify"><%= request.getAttribute("pendingVerificationsCount") %></span>
                    <% } %>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>Kelola Laporan</span>
                    <% if (request.getAttribute("pendingReportsCount") != null && (int)request.getAttribute("pendingReportsCount") > 0) { %>
                        <span class="badge badge-report"><%= request.getAttribute("pendingReportsCount") %></span>
                    <% } %>
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
                    <h1 class="main-title">Dashboard</h1>
                    <ul class="breadcrumb">
                        <li><a href="#">Admin</a></li>
                        <li><i class="fa-solid fa-chevron-right separator"></i></li>
                        <li class="active">Dashboard</li>
                    </ul>
                </div>
                <div class="header-date">
                    <i class="fa-regular fa-calendar-days"></i>
                    <span id="current-date">Rabu, 10 Juni 2026</span>
                </div>
            </header>

            <!-- STATS GRID -->
            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon-wrapper users-bg">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-label">Total Pengguna</span>
                        <h3 class="stat-value"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %></h3>
                    </div>
                    <div class="stat-badge positive">
                        <i class="fa-solid fa-arrow-up"></i>
                        <span>Update</span>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon-wrapper props-bg">
                        <i class="fa-solid fa-building"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-label">Total Properti</span>
                        <h3 class="stat-value"><%= request.getAttribute("totalProperties") != null ? request.getAttribute("totalProperties") : "0" %></h3>
                    </div>
                    <div class="stat-badge positive">
                        <i class="fa-solid fa-check"></i>
                        <span>Aktif</span>
                    </div>
                </div>

                <div class="stat-card clickable-card" onclick="location.href='${pageContext.request.contextPath}/admin/verify'">
                    <div class="stat-icon-wrapper verify-bg">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-label">Pending Verifikasi</span>
                        <h3 class="stat-value"><%= request.getAttribute("pendingVerificationsCount") != null ? request.getAttribute("pendingVerificationsCount") : "0" %></h3>
                    </div>
                    <% if (request.getAttribute("pendingVerificationsCount") != null && (int)request.getAttribute("pendingVerificationsCount") > 0) { %>
                        <div class="stat-badge warning">
                            <i class="fa-solid fa-circle-exclamation animate-pulse"></i>
                            <span>Butuh Review</span>
                        </div>
                    <% } else { %>
                        <div class="stat-badge success">
                            <i class="fa-solid fa-circle-check"></i>
                            <span>Selesai</span>
                        </div>
                    <% } %>
                </div>

                <div class="stat-card clickable-card" onclick="location.href='${pageContext.request.contextPath}/admin/reports'">
                    <div class="stat-icon-wrapper reports-bg">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-label">Laporan Masuk</span>
                        <h3 class="stat-value"><%= request.getAttribute("pendingReportsCount") != null ? request.getAttribute("pendingReportsCount") : "0" %></h3>
                    </div>
                    <% if (request.getAttribute("pendingReportsCount") != null && (int)request.getAttribute("pendingReportsCount") > 0) { %>
                        <div class="stat-badge danger">
                            <i class="fa-solid fa-triangle-exclamation animate-pulse"></i>
                            <span>Pending</span>
                        </div>
                    <% } else { %>
                        <div class="stat-badge success">
                            <i class="fa-solid fa-circle-check"></i>
                            <span>Clear</span>
                        </div>
                    <% } %>
                </div>
            </section>

            <!-- DASHBOARD SECTION -->
            <section class="dashboard-content">
                <!-- QUICK ACTIONS -->
                <div class="action-card-container">
                    <h2 class="section-title">Menu Cepat Administrasi</h2>
                    <div class="action-grid">
                        <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
                            <div class="action-icon u-color"><i class="fa-solid fa-user-gear"></i></div>
                            <div class="action-info">
                                <h4>Kelola User</h4>
                                <p>Lihat daftar tenant dan owner, suspend atau aktifkan akun pengguna.</p>
                            </div>
                            <i class="fa-solid fa-chevron-right arrow-next"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/verify" class="action-card">
                            <div class="action-icon v-color"><i class="fa-solid fa-file-signature"></i></div>
                            <div class="action-info">
                                <h4>Verifikasi Properti</h4>
                                <p>Tinjau pengajuan properti baru dari owner, setujui atau tolak properti.</p>
                            </div>
                            <i class="fa-solid fa-chevron-right arrow-next"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/reports" class="action-card">
                            <div class="action-icon r-color"><i class="fa-solid fa-flag-checkered"></i></div>
                            <div class="action-info">
                                <h4>Kelola Laporan</h4>
                                <p>Periksa keluhan dari tenant terkait iklan palsu atau properti bermasalah.</p>
                            </div>
                            <i class="fa-solid fa-chevron-right arrow-next"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/flagged" class="action-card">
                            <div class="action-icon f-color"><i class="fa-solid fa-circle-minus"></i></div>
                            <div class="action-info">
                                <h4>Properti Bermasalah</h4>
                                <p>Pantau properti yang ditandai (flagged), cabut tanda atau hapus iklan secara permanen.</p>
                            </div>
                            <i class="fa-solid fa-chevron-right arrow-next"></i>
                        </a>
                    </div>
                </div>

                <!-- SYSTEM STATE -->
                <div class="system-status-card">
                    <h2 class="section-title">Status Sistem</h2>
                    <div class="status-list">
                        <div class="status-item">
                            <span class="status-label">Database Connection</span>
                            <span class="status-value text-success"><i class="fa-solid fa-circle-check"></i> Terhubung</span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Apache Tomcat Server</span>
                            <span class="status-value text-success"><i class="fa-solid fa-circle-check"></i> Berjalan</span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Cloudinary Storage API</span>
                            <span class="status-value text-success"><i class="fa-solid fa-circle-check"></i> Siap</span>
                        </div>
                        <div class="status-item">
                            <span class="status-label">Waktu Sistem</span>
                            <span id="system-time" class="status-value text-muted">--:--:--</span>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard_admin.js"></script>
</body>
</html>
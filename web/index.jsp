<%-- Document : index Created on : Jun 1, 2026, 11:32:42 AM Author : Lenovo --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="assets/css/global.css" />
    <link rel="stylesheet" href="assets/css/components.css" />
    <link rel="stylesheet" href="assets/css/landing.css" />
    <title>SewaIn - Temukan Hunian Impian Anda</title>
  </head>
  <body>
    <!-- ===== HERO SECTION ===== -->
    <section class="hero">
      <div class="container">
        <nav class="navbar">
          <div class="nav-wrapper">
            <div class="logo">SewaIn</div>
            <div class="nav-auth">
              <a href="pages/auth/login.jsp" class="btn-login"
                >Login / Daftar</a
              >
            </div>
          </div>
        </nav>

        <div class="hero-content">
          <div class="hero-left">
            <!-- hero-badge removed per request -->
            <h1>
              Temukan<br />
              <span class="hero-highlight">Hunian Impian</span><br />
              Anda
            </h1>
            <p class="hero-desc">
              Sewa apartemen, rumah, dan kost premium dengan mudah, aman, dan
              terpercaya. Pilihan terbaik untuk gaya hidup modern.
            </p>
            <!-- search box removed per request -->
            <!-- hero-stats removed per request -->
          </div>

          <div class="hero-right">
            <div class="property-card hero-card">
              <div class="property-img-wrapper hero-card-img-wrapper">
                <img
                  src="assets/images/landing/hero-property.jpg"
                  alt="The Grand Residence"
                  onerror="this.style.visibility = 'hidden'"
                />
                <div class="property-tag verified">
                  <img class="tag-icon" src="assets/images/icon/verif.png" alt="" />
                  VERIFIED
                </div>
                <button class="property-wishlist" aria-label="Wishlist">
                  <svg
                    width="18"
                    height="18"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                    />
                  </svg>
                </button>
                <div class="property-available">AVAILABLE NOW</div>
              </div>

              <div class="property-content hero-card-content">
                <div class="property-top-row">
                  <h3 class="property-name">The Grand Residence</h3>
                  <span class="property-price">Rp 15M</span>
                </div>
                <p class="property-location">
                  <svg
                    width="13"
                    height="13"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"
                    />
                    <circle cx="12" cy="9" r="2.5" />
                  </svg>
                  Jakarta Selatan
                </p>
                <div class="property-meta">
                  <span>
                    <img class="property-meta-icon" src="assets/images/icon/kamar.png" alt="" />
                    3
                  </span>
                  <span>
                    <img class="property-meta-icon" src="assets/images/icon/kamarmandi.png" alt="" />
                    2
                  </span>
                  <span>
                    <img class="property-meta-icon" src="assets/images/icon/luas.png" alt="" />
                    120m&sup2;
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="property-section">
      <div class="container">
        <div class="property-header reveal-header">
          <div>
            <h2 class="section-title">Properti Unggulan</h2>
            <p class="section-subtitle">
              Pilihan premium yang telah dikurasi untuk Anda.
            </p>
          </div>
          <a href="pages/auth/login.jsp" class="btn-see-all">
            Lihat Semua
            <svg
              width="16"
              height="16"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
            >
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg>
          </a>
        </div>

        <div class="property-grid">
          <!-- Card 1 -->
          <div class="property-card reveal-card">
            <div class="property-img-wrapper">
              <img
                src="assets/images/landing/property1.jpg"
                alt="The Senopati Suites"
                onerror="this.style.visibility = 'hidden'"
              />
              <div class="property-tag verified">
                <img class="tag-icon" src="assets/images/icon/verif.png" alt="" />
                VERIFIED
              </div>
              <button class="property-wishlist" aria-label="Wishlist">
                <svg
                  width="18"
                  height="18"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                  />
                </svg>
              </button>
              <div class="property-available">AVAILABLE NOW</div>
            </div>
            <div class="property-content">
              <div class="property-top-row">
                <h3 class="property-name">The Senopati Suites</h3>
                <span class="property-price">Rp 12M</span>
              </div>
              <p class="property-location">
                <svg
                  width="13"
                  height="13"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"
                  />
                  <circle cx="12" cy="9" r="2.5" />
                </svg>
                Senopati, Jakarta Selatan
              </p>
              <div class="property-meta">
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/kamar.png" alt="" />
                  2
                </span>
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/kamarmandi.png" alt="" />
                  2
                </span>
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/luas.png" alt="" />
                  85m&sup2;
                </span>
              </div>
            </div>
          </div>

          <!-- Card 2 -->
          <div class="property-card reveal-card">
            <div class="property-img-wrapper">
              <img
                src="assets/images/landing/property2.jpg"
                alt="Serenity Villa Kemang"
                onerror="this.style.visibility = 'hidden'"
              />
              <div class="property-tag verified">
                <img class="tag-icon" src="assets/images/icon/verif.png" alt="" />
                VERIFIED
              </div>
              <button class="property-wishlist" aria-label="Wishlist">
                <svg
                  width="18"
                  height="18"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                  />
                </svg>
              </button>
              <div class="property-available">AVAILABLE NOW</div>
            </div>
            <div class="property-content">
              <div class="property-top-row">
                <h3 class="property-name">Serenity Villa Kemang</h3>
                <span class="property-price">Rp 12M</span>
              </div>
              <p class="property-location">
                <svg
                  width="13"
                  height="13"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"
                  />
                  <circle cx="12" cy="9" r="2.5" />
                </svg>
                Kemang, Jakarta Selatan
              </p>
              <div class="property-meta">
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/kamar.png" alt="" />
                  2
                </span>
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/kamarmandi.png" alt="" />
                  2
                </span>
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/luas.png" alt="" />
                  85m&sup2;
                </span>
              </div>
            </div>
          </div>

          <!-- Card 3 -->
          <div class="property-card reveal-card">
            <div class="property-img-wrapper">
              <img
                src="assets/images/landing/property3.jpg"
                alt="Skyline Suites Sudirman"
                onerror="this.style.visibility = 'hidden'"
              />
              <div class="property-tag verified">
                <img class="tag-icon" src="assets/images/icon/verif.png" alt="" />
                VERIFIED
              </div>
              <button class="property-wishlist" aria-label="Wishlist">
                <svg
                  width="18"
                  height="18"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                  />
                </svg>
              </button>
              <div class="property-available">AVAILABLE NOW</div>
            </div>
            <div class="property-content">
              <div class="property-top-row">
                <h3 class="property-name">Skyline Suites Sudirman</h3>
                <span class="property-price">Rp 12M</span>
              </div>
              <p class="property-location">
                <svg
                  width="13"
                  height="13"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"
                  />
                  <circle cx="12" cy="9" r="2.5" />
                </svg>
                Sudirman, Jakarta Selatan
              </p>
              <div class="property-meta">
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/kamar.png" alt="" />
                  3
                </span>
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/kamarmandi.png" alt="" />
                  2
                </span>
                <span>
                  <img class="property-meta-icon" src="assets/images/icon/luas.png" alt="" />
                  85m&sup2;
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="curation">
      <div class="container">
        <div class="curation-content">
          <div class="curation-left">
            <h2 class="section-title">Standar Kurasi<br />SewaIn</h2>
            <p class="curation-desc">
              Kami memastikan setiap properti yang terdaftar memenuhi standar
              kenyamanan dan keamanan yang tinggi. Kenali lencana status kami.
            </p>
            <div class="curation-list">
              <div class="curation-box verified-box">
                <div class="curation-icon verified-icon">
                  <svg
                    width="20"
                    height="20"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div>
                  <h3>Verified Property</h3>
                  <p>
                    Properti telah dikunjungi, difoto, dan diverifikasi
                    keasliannya oleh tim kurator kami. Transaksi dijamin aman.
                  </p>
                </div>
              </div>
              <div class="curation-box review-box">
                <div class="curation-icon review-icon">
                  <svg
                    width="20"
                    height="20"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <circle cx="12" cy="12" r="10" />
                    <path d="M12 6v6l4 2" />
                  </svg>
                </div>
                <div>
                  <h3>Under Review</h3>
                  <p>
                    Properti sedang dalam tahap verifikasi dokumen dan
                    penjadwalan kunjungan fisik oleh tim kami.
                  </p>
                </div>
              </div>
              <div class="curation-box rejected-box">
                <div class="curation-icon rejected-icon">
                  <svg
                    width="20"
                    height="20"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <circle cx="12" cy="12" r="10" />
                    <path d="M15 9l-6 6M9 9l6 6" />
                  </svg>
                </div>
                <div>
                  <h3>Rejected Property</h3>
                  <p>
                    Properti yang tidak memenuhi standar kualitas dan keamanan
                    kami akan ditolak untuk menjaga kepercayaan komunitas.
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div class="curation-right">
            <div class="curation-img-wrapper">
              <img
                src="assets/images/landing/verification.png"
                alt="Verification process"
              />
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="trust">
      <div class="container">
        <div class="trust-wrapper">
          <div class="trust-left">
            <h2 class="section-title">
              Kepercayaan &amp;<br />Kenyamanan Anda<br />Prioritas Kami
            </h2>
            <p class="trust-desc">
              Setiap properti di SewaIn melewati proses verifikasi ketat untuk
              memastikan kualitas dan keamanan. Transaksi transparan tanpa biaya
              tersembunyi.
            </p>
            <div class="trust-list">
              <div class="trust-item">
                <div class="trust-icon">
                  <svg
                    width="18"
                    height="18"
                    fill="none"
                    stroke="white"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <span>100% Verifikasi Properti &amp; Pemilik</span>
              </div>
              <div class="trust-item">
                <div class="trust-icon">
                  <svg
                    width="18"
                    height="18"
                    fill="none"
                    stroke="white"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <rect x="1" y="4" width="22" height="16" rx="2" ry="2" />
                    <line x1="1" y1="10" x2="23" y2="10" />
                  </svg>
                </div>
                <span>Pembayaran Aman &amp; Fleksibel</span>
              </div>
              <div class="trust-item">
                <div class="trust-icon">
                  <svg
                    width="18"
                    height="18"
                    fill="none"
                    stroke="white"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"
                    />
                  </svg>
                </div>
                <span>Dukungan Pelanggan 24/7</span>
              </div>
            </div>
          </div>
          <div class="trust-right">
            <img src="assets/images/landing/trust.png" alt="Trust & Safety" />
          </div>
        </div>
      </div>
    </section>

    <!-- ===== FOOTER (SIMPLE) ===== -->
    <footer class="footer">
      <div class="container">
        <div
          class="footer-simple"
          style="
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 18px 0;
          "
        >
          <div>
            <h3 class="footer-logo">SewaIn</h3>
            <p
              style="
                margin: 4px 0;
                color: var(--text-secondary);
                font-size: 13px;
              "
            >
              Temukan hunian impian Anda
            </p>
          </div>
          <nav
            class="footer-nav"
            style="display: flex; gap: 18px; align-items: center"
          >
            <a href="pages/auth/login.jsp">Login</a>
            <a href="pages/auth/login.jsp">Daftar</a>
            <a href="pages/auth/login.jsp">Kontak</a>
          </nav>
        </div>
        <div class="footer-bottom" style="padding-top: 12px">
          <span style="color: var(--text-secondary); font-size: 13px">
            &copy; 2026 SewaIn. All rights reserved.
          </span>
        </div>
      </div>
    </footer>

    <!-- ===== JAVASCRIPT — Scroll Reveal & Interactions ===== -->
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // ── Intersection Observer for scroll reveal ──
        var revealElements = document.querySelectorAll(".reveal-card, .reveal-header");

        var revealObserver = new IntersectionObserver(
          function (entries) {
            entries.forEach(function (entry) {
              if (entry.isIntersecting) {
                entry.target.classList.add("revealed");
                revealObserver.unobserve(entry.target);
              }
            });
          },
          {
            threshold: 0.15,
            rootMargin: "0px 0px -40px 0px"
          }
        );

        revealElements.forEach(function (el) {
          revealObserver.observe(el);
        });

        // ── Wishlist toggle with heart animation ──
        var wishlistBtns = document.querySelectorAll(".property-wishlist");
        wishlistBtns.forEach(function (btn) {
          btn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();
            this.classList.toggle("active");

            // Pop animation
            this.classList.add("pop");
            var self = this;
            setTimeout(function () {
              self.classList.remove("pop");
            }, 400);
          });
        });

        // ── Parallax tilt effect on card hover ──
        var cards = document.querySelectorAll(".property-grid .property-card");
        cards.forEach(function (card) {
          card.addEventListener("mousemove", function (e) {
            var rect = card.getBoundingClientRect();
            var x = e.clientX - rect.left;
            var y = e.clientY - rect.top;
            var centerX = rect.width / 2;
            var centerY = rect.height / 2;
            var rotateX = ((y - centerY) / centerY) * -3;
            var rotateY = ((x - centerX) / centerX) * 3;

            card.style.transform =
              "translateY(-10px) perspective(800px) rotateX(" +
              rotateX +
              "deg) rotateY(" +
              rotateY +
              "deg)";
          });

          card.addEventListener("mouseleave", function () {
            card.style.transform = "";
          });
        });
      });
    </script>
  </body>
</html>

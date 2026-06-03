<%-- 
    Document   : login
    Created on : Jun 3, 2026, 8:46:11 AM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - SewaIn</title>

    <link rel="stylesheet" href="../../assets/css/global.css">
    <link rel="stylesheet" href="../../assets/css/login.css">

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>

<body>

<div class="login-container">

    <div class="login-banner">

        <img src="../../assets/images/auth/login-banner.png"
             alt="Login Banner">

        <div class="banner-overlay">

            <h1>
                Elevate Your<br>
                Living Experience
            </h1>

            <p>
                Discover curated spaces designed
                for comfort, trust and modern living.
            </p>

        </div>

    </div>

    <div class="login-form-section">

        <div class="login-card">

            <h2>Log In</h2>

            <p class="subtitle">
                Enter your details to join SewaIn.
            </p>

            <form action="../../LoginServlet"
                  method="post">

                <div class="form-group">

                    <label>Email Address</label>

                    <input
                        type="email"
                        name="email"
                        placeholder="john@example.com"
                        required>

                </div>

                <div class="form-group">

                    <label>Password</label>

                    <input
                        type="password"
                        name="password"
                        placeholder="••••••••"
                        required>

                </div>

                <button type="submit"
                        class="login-btn">

                    Login

                </button>

            </form>

            <p class="register-link">

                Don't have an account?

                <a href="register.jsp">
                    Sign Up
                </a>

            </p>

        </div>

    </div>

</div>

</body>
</html>

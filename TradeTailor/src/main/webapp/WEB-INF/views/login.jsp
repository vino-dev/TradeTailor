<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - TradeTailor</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url('https://images.unsplash.com/photo-1556742031-c6961e8560b0?auto=format&fit=crop&w=1950&q=80') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.25);
            max-width: 400px;
            margin: 100px auto;
            padding: 40px 30px;
            text-align: center;
        }

        .login-container h2 {
            color: #2d2d2d;
            margin-bottom: 30px;
        }

        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 12px;
            margin: 12px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
        }

        button {
            background-color: #1a73e8;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }

        button:hover {
            background-color: #155db2;
        }

        p {
            margin-top: 15px;
        }

        a {
            color: #1a73e8;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login to TradeTailor</h2>

        <form id="loginForm">
            <input type="text" name="username" placeholder="Username" required /><br>
            <input type="password" name="password" placeholder="Password" required /><br>
            <button type="submit">Login</button>
        </form>

        <p>New here? <a href="/register">Register now</a></p>
    </div>

    <script>
        document.getElementById("loginForm").addEventListener("submit", function (e) {
            e.preventDefault();

            const data = {
                username: this.username.value,
                password: this.password.value
            };

            fetch("/api/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(data)
            })
            .then(res => res.text())
            .then(msg => {
                alert(msg);
                if (msg.includes("successful")) {
                    window.location.href = "/home";
                }
            })
            .catch(err => {
                alert("Login failed. Please check your credentials.");
                console.error(err);
            });
        });
    </script>
</body>
</html>

<!DOCTYPE html>
<html>
<head>
    <title>Register - TradeTailor</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom right, #e0f7fa, #e1bee7);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-container {
            background: white;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
            color: #555;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 25px;
            background-color: #6200ea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #4500b3;
        }
    </style>
</head>
<body>

    <div class="register-container">
        <h2>Register</h2>
        <form id="registerForm">
            <label>Name:</label>
            <input type="text" name="name" required />

            <label>Email:</label>
            <input type="email" name="email" required />

            <label>Mobile:</label>
            <input type="text" name="mobile" required />

            <label>Username:</label>
            <input type="text" name="username" required />

            <label>Password:</label>
            <input type="password" name="password" required />

            <button type="submit">Register</button>
             <p>Registered user? <a href="/login">login now</a></p>
        </form>
    </div>

    <script>
    document.getElementById("registerForm").addEventListener("submit", function (e) {
        e.preventDefault();
        const data = {
            name: this.name.value,
            email: this.email.value,
            mobile: this.mobile.value,
            username: this.username.value,
            password: this.password.value
        };

        fetch("/api/register", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
        .then(res => res.text())
        .then(msg => {
            alert(msg);
            if (msg.includes("OTP")) {
                window.location.href = "/verify-otp?email=" + encodeURIComponent(data.email);
            }
        });
    });
    </script>

</body>
</html>

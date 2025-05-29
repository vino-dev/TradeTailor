<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP - TradeTailor</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to bottom right, #fbe9e7, #ffe0b2);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .otp-container {
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

        input[type="text"] {
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
            background-color: #f57c00;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #e65100;
        }
    </style>
</head>
<body>

<div class="otp-container">
    <h2>Verify OTP</h2>
    <form id="otpForm">
        <label>OTP:</label>
        <input type="text" name="otp" required />
        <button type="submit">Verify</button>
    </form>
</div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    const email = urlParams.get("email");

    document.getElementById("otpForm").addEventListener("submit", function (e) {
        e.preventDefault();
        const data = {
            email: email,
            otp: this.otp.value
        };

        fetch("/api/verify-otp", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
        .then(res => res.text())
        .then(msg => {
            alert(msg);
            if (msg.includes("verified")) {
                window.location.href = "/login";
            }
        });
    });
</script>

</body>
</html>

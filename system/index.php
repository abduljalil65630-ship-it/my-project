<?php
$message = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $pdo = null;

    try {
        $pdo = new PDO(
            "mysql:host=localhost;dbname=bank;charset=utf8",
            "root",
            "",
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );

        // بدء المعاملة
        $pdo->beginTransaction();

        // القيم من الفورم
        $from   = $_POST['from'];
        $to     = $_POST['to'];
        $amount = $_POST['amount'];

        // 1️⃣ خصم الرصيد من الحساب الأول
        $stmt = $pdo->prepare(
            "UPDATE accounts 
             SET balance = balance - :amount 
             WHERE id = :id AND balance >= :amount"
        );
        $stmt->execute([
            'amount' => $amount,
            'id' => $from
        ]);

        if ($stmt->rowCount() === 0) {
            throw new Exception("رصيد غير كافٍ");
        }

        // 2️⃣ إضافة الرصيد للحساب الثاني
        $stmt = $pdo->prepare(
            "UPDATE accounts 
             SET balance = balance + :amount 
             WHERE id = :id"
        );
        $stmt->execute([
            'amount' => $amount,
            'id' => $to
        ]);

        // 3️⃣ تسجيل العملية
        $stmt = $pdo->prepare(
            "INSERT INTO transactions (from_account, to_account, amount, created_at)
             VALUES (?, ?, ?, NOW())"
        );
        $stmt->execute([$from, $to, $amount]);

        // نجاح كامل
        $pdo->commit();
        $message = "✅ تم التحويل بنجاح";

    } catch (Exception $e) {

        // rollback عند الخطأ
        if ($pdo && $pdo->inTransaction()) {
            $pdo->rollBack();
        }

        // تسجيل الخطأ في logs
        if ($pdo) {
            $stmt = $pdo->prepare(
                "INSERT INTO logs (message, level, created_at)
                 VALUES (?, 'ERROR', NOW())"
            );
            $stmt->execute([$e->getMessage()]);
        }

        // رسالة آمنة للمستخدم
        $message = "❌ حدث خطأ أثناء تنفيذ العملية";
    }
}
?>
<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <title>تحويل أموال</title>
    <style>
        body {
            font-family: Arial;
            background: #f5f5f5;
            direction: rtl;
        }
        .box {
            width: 400px;
            margin: 50px auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
        }
        input, button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
        }
        button {
            background: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        .msg {
            margin-top: 15px;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="box">
    <h3>نظام تحويل أموال</h3>

    <form method="POST">
        <input type="number" name="from" placeholder="رقم الحساب المرسل" required>
        <input type="number" name="to" placeholder="رقم الحساب المستلم" required>
        <input type="number" name="amount" placeholder="المبلغ" required>
        <button type="submit">تحويل</button>
    </form>

    <?php if ($message): ?>
        <div class="msg"><?= $message ?></div>
    <?php endif; ?>
</div>

</body>
</html>

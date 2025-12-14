<?php
// date() : تعرض التاريخ والوقت الحالي بالتنسيق الذي تختاره
echo date("Y-m-d H:i:s"); // مثال: 2025-12-14 17:55:10
echo '<br>';
// time() : ترجع عدد الثواني منذ 1 يناير 1970 (Timestamp)
echo time(); // مثال: 1734197410
echo '<br>';
// strtotime() : تحول نص زمني إلى Timestamp
echo date("Y-m-d", strtotime("+3 days")); // مثال: 2025-12-17
echo '<br>';
// getdate() : ترجع مصفوفة تحتوي كل تفاصيل التاريخ والوقت
$today = getdate();
echo $today['year']; // مثال: 2025
echo '<br>';
// date_default_timezone_set() : لتحديد المنطقة الزمنية
date_default_timezone_set("Asia/Aden");
echo date("H:i:s"); // الوقت حسب اليمن
echo '<br>';
// checkdate() : تتحقق من صحة التاريخ
if(checkdate(2,29,2024)){
    echo "تاريخ صحيح"; // يظهر إذا كان التاريخ صحيح
}
echo '<br>';
// microtime() : ترجع الوقت الحالي مع أجزاء من الثانية
echo microtime(true); // مثال: 1734197410.1234
echo '<br>';
?>

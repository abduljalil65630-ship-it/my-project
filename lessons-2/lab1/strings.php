<?php
// ===========================s
// جميع أمثلة دوال النصوص في PHP مع الشرح
// ===========================

// 1) strlen() - طول النص
echo "<h3>1) strlen()</h3>";
$str = "Hello World";
echo strlen($str);

// 2) str_word_count() - عدد الكلمات
echo "<h3>2) str_word_count()</h3>";
$str = "Hello World from PHP";
echo str_word_count($str);

// 3) strrev() - عكس النص
echo "<h3>3) strrev()</h3>";
$str = "Hello";
echo strrev($str);

// 4) strpos() - البحث عن موقع نص داخل نص
echo "<h3>4) strpos()</h3>";
$str = "Hello World";
echo strpos($str, "World");

// 5) stripos() - البحث بدون مراعاة حالة الأحرف
echo "<h3>5) stripos()</h3>";
$str = "Hello World";
echo stripos($str, "world");

// 6) substr() - استخراج جزء من النص
echo "<h3>6) substr()</h3>";
$str = "Hello World";
echo substr($str, 6, 5);

// 7) str_replace() - استبدال نص
echo "<h3>7) str_replace()</h3>";
$str = "Hello World";
echo str_replace("World", "PHP", $str);

// 8) str_ireplace() - استبدال نص بدون مراعاة الأحرف
echo "<h3>8) str_ireplace()</h3>";
$str = "Hello World";
echo str_ireplace("world", "PHP", $str);

// 9) strtoupper() - تحويل النص إلى أحرف كبيرة
echo "<h3>9) strtoupper()</h3>";
$str = "Hello";
echo strtoupper($str);

// 10) strtolower() - تحويل النص إلى أحرف صغيرة
echo "<h3>10) strtolower()</h3>";
$str = "Hello";
echo strtolower($str);

// 11) ucfirst() - أول حرف كبير
echo "<h3>11) ucfirst()</h3>";
$str = "hello world";
echo ucfirst($str);

// 12) ucwords() - أول حرف كل كلمة كبير
echo "<h3>12) ucwords()</h3>";
$str = "hello world";
echo ucwords($str);

// 13) trim() - إزالة الفراغات من البداية والنهاية
echo "<h3>13) trim()</h3>";
$str = "  Hello World  ";
echo trim($str);

// 14) ltrim() / rtrim() - إزالة الفراغات من البداية أو النهاية
echo "<h3>14) ltrim() / rtrim()</h3>";
$str = "  Hello World  ";
echo "[".ltrim($str)."]<br>";
echo "[".rtrim($str)."]";

// 15) explode() - تحويل النص إلى مصفوفة حسب فاصل
echo "<h3>15) explode()</h3>";
$str = "apple,banana,orange";
$arr = explode(",", $str);
print_r($arr);

// 16) implode() / join() - تحويل مصفوفة إلى نص
echo "<h3>16) implode() / join()</h3>";
$arr = ["apple","banana","orange"];
$str = implode(" - ", $arr);
echo $str;

// 17) htmlspecialchars() - تحويل الأحرف الخاصة للـ HTML
echo "<h3>17) htmlspecialchars()</h3>";
$str = "<div>Hello</div>";
echo htmlspecialchars($str);

// 18) html_entity_decode() - تحويل الكيانات HTML إلى نص
echo "<h3>18) html_entity_decode()</h3>";
$str = "&lt;div&gt;Hello&lt;/div&gt;";
echo html_entity_decode($str);

// 19) nl2br() - تحويل السطر الجديد إلى <br>
echo "<h3>19) nl2br()</h3>";
$str = "Hello\nWorld";
echo nl2br($str);

// 20) strcmp() / strcasecmp() - مقارنة نصوص
echo "<h3>20) strcmp() / strcasecmp()</h3>";
$str1 = "Hello";
$str2 = "hello";
echo strcmp($str1, $str2) . "<br>";  // فرق حسب الأحرف
echo strcasecmp($str1, $str2);        // بدون مراعاة الأحرف

// 21) str_repeat() - تكرار النص
echo "<h3>21) str_repeat()</h3>";
echo str_repeat("Hello ", 3);

// 22) str_pad() - ملء النص بمسافات أو أحرف
echo "<h3>22) str_pad()</h3>";
echo str_pad("Hello", 10, "-");

// 23) wordwrap() - تقسيم النصوص الطويلة
echo "<h3>23) wordwrap()</h3>";
$str = "Hello world, this is PHP!";
echo wordwrap($str, 10, "<br>");

// 24) addslashes() / stripslashes() - إضافة أو إزالة شرطات الهروب
echo "<h3>24) addslashes() / stripslashes()</h3>";
$str = "O'Reilly";
echo addslashes($str) . "<br>";
echo stripslashes(addslashes($str));

?>
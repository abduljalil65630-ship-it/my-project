<?php
// ===========================
// ملف arrays.php
// جميع أمثلة دوال المصفوفات في PHP مع الشرح
// ===========================

// 1) إنشاء مصفوفة
echo "<h3>1) array()</h3>";
$arr = array(1, 2, 3);
print_r($arr);

// 2) range() - إنشاء مصفوفة متسلسلة
echo "<h3>2) range()</h3>";
$arr = range(1,5);
print_r($arr);

// 3) in_array() - التحقق من وجود قيمة
echo "<h3>3) in_array()</h3>";
$arr = ["apple","banana"];
echo in_array("banana",$arr) ? "تم العثور على banana" : "غير موجود";

// 4) array_search() - البحث عن مفتاح القيمة
echo "<h3>4) array_search()</h3>";
$arr = ["a"=>10,"b"=>20];
echo array_search(20,$arr);

// 5) array_key_exists() - التحقق من وجود مفتاح
echo "<h3>5) array_key_exists()</h3>";
$arr = ["name"=>"Ali"];
echo array_key_exists("name",$arr) ? "المفتاح موجود" : "المفتاح غير موجود";

// 6) array_push() - إضافة عنصر في النهاية
echo "<h3>6) array_push()</h3>";
$arr = [1,2];
array_push($arr,3);
print_r($arr);

// 7) array_pop() - إزالة آخر عنصر
echo "<h3>7) array_pop()</h3>";
array_pop($arr);
print_r($arr);

// 8) array_shift() - إزالة أول عنصر
echo "<h3>8) array_shift()</h3>";
array_shift($arr);
print_r($arr);

// 9) array_unshift() - إضافة عنصر في البداية
echo "<h3>9) array_unshift()</h3>";
array_unshift($arr,1);
print_r($arr);

// 10) array_merge() - دمج مصفوفتين
echo "<h3>10) array_merge()</h3>";
$a = [1,2];
$b = [3,4];
print_r(array_merge($a,$b));

// 11) sort() - فرز تصاعدي
echo "<h3>11) sort()</h3>";
$arr = [3,1,2];
sort($arr);
print_r($arr);

// 12) rsort() - فرز تنازلي
echo "<h3>12) rsort()</h3>";
rsort($arr);
print_r($arr);

// 13) asort() - فرز القيم مع المحافظة على المفاتيح
echo "<h3>13) asort()</h3>";
$arr = ["b"=>20,"a"=>10];
asort($arr);
print_r($arr);

// 14) ksort() - فرز حسب المفاتيح
echo "<h3>14) ksort()</h3>";
ksort($arr);
print_r($arr);

// 15) array_map() - تطبيق دالة على كل عنصر
echo "<h3>15) array_map()</h3>";
$arr = [1,2,3];
$result = array_map(fn($x)=>$x*2,$arr);
print_r($result);

// 16) array_filter() - تصفية المصفوفة
echo "<h3>16) array_filter()</h3>";
$arr = [1,2,3,4,5];
print_r(array_filter($arr,fn($x)=>$x>3));

// 17) array_reduce() - دمج القيم في قيمة واحدة
echo "<h3>17) array_reduce()</h3>";
$arr = [1,2,3,4];
$sum = array_reduce($arr,fn($carry,$item)=>$carry+$item,0);
echo $sum;

// 18) count() - عدد العناصر
echo "<h3>18) count()</h3>";
$arr = [1,2,3];
echo count($arr);

// 19) array_keys() - جميع المفاتيح
echo "<h3>19) array_keys()</h3>";
$arr = ["name"=>"Ali","age"=>20];
print_r(array_keys($arr));

// 20) array_values() - جميع القيم
echo "<h3>20) array_values()</h3>";
print_r(array_values($arr));

// 21) shuffle() - خلط المصفوفة
echo "<h3>21) shuffle()</h3>";
$arr = [1,2,3,4];
shuffle($arr);
print_r($arr);

// 22) مؤشرات المصفوفة: current, next, end, reset
echo "<h3>22) Pointers (current/next/end/reset)</h3>";
$arr = [10,20,30];
echo current($arr) . "<br>"; // 10
next($arr);
echo current($arr) . "<br>"; // 20
end($arr);
echo current($arr) . "<br>"; // 30
reset($arr);
echo current($arr) . "<br>"; // 10

?>
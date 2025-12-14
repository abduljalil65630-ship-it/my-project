<?php
// fopen() : فتح ملف للقراءة 'r' أو الكتابة 'w' أو الإضافة 'a'
$file = fopen("test.txt", "w"); // فتح ملف جديد للكتابة
echo '<br>';
// fwrite() : كتابة نص داخل الملف المفتوح
fwrite($file, "مرحبا PHP"); // كتابة النص
echo '<br>';
// fclose() : إغلاق الملف بعد الانتهاء
fclose($file);
echo '<br>';
// fread() : قراءة محتوى الملف المفتوح حسب حجم معين
$file = fopen("test.txt", "r"); // فتح الملف للقراءة
echo fread($file, filesize("test.txt")); // قراءة كل محتوى الملف
fclose($file);
echo '<br>';
// fgets() : قراءة سطر واحد من الملف
$file = fopen("test.txt", "r");
echo fgets($file); // قراءة السطر الأول
fclose($file);
echo '<br>';
// file_get_contents() : قراءة الملف كامل دفعة واحدة بدون fopen
echo file_get_contents("test.txt");
echo '<br>';
// file_put_contents() : كتابة نص مباشرة داخل الملف
file_put_contents("test.txt", "نص جديد");
echo '<br>';
// file_exists() : التحقق إذا كان الملف موجود
if(file_exists("test.txt")){
    echo "الملف موجود";
}
echo '<br>';
// filesize() : معرفة حجم الملف بالبايت
echo filesize("test.txt");
echo '<br>';
// unlink() : حذف الملف
unlink("test.txt");
echo '<br>';
// copy() : نسخ الملف إلى اسم آخر
copy("a.txt", "b.txt");
echo '<br>';
// rename() : إعادة تسمية الملف أو نقله
rename("b.txt", "c.txt");
echo '<br>';
// mkdir() : إنشاء مجلد جديد
mkdir("folder");
echo '<br>';
// rmdir() : حذف مجلد فارغ
rmdir("folder");
echo '<br>';
// scandir() : عرض محتويات المجلد
print_r(scandir("."));
echo '<br>';
// pathinfo() : معلومات عن الملف (المسار، الاسم، الامتداد)
print_r(pathinfo("a.txt"));
echo '<br>';
// basename() : عرض اسم الملف فقط
echo basename("folder/a.txt");
echo '<br>';
// dirname() : عرض اسم المجلد فقط
echo dirname("folder/a.txt");
echo '<br>';
?>
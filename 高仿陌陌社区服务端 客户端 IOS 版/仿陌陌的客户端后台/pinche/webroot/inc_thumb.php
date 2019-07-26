<?php
/*���캯��-��������ͼ+ˮӡ,����˵��:
$srcFile-ͼƬ�ļ���,
$dstFile-����ļ���,
$markwords-ˮӡ����,
$markimage-ˮӡͼƬ,
$dstW-ͼƬ������,
$dstH-ͼƬ����߶�,
$rate-ͼƬ����Ʒ��
makethumb("a.jpg","b.jpg","50","50");
*/

function makethumb($srcFile,$dstFile,$dstW,$dstH,$rate=100,$markwords=null,$markimage=null) 
{ 
$data = GetImageSize($srcFile); 
switch($data[2]) 
{ 
case 1: 
$im=@ImageCreateFromGIF($srcFile); 
break; 
case 2: 
$im=@ImageCreateFromJPEG($srcFile); 
break; 
case 3: 
$im=@ImageCreateFromPNG($srcFile); 
break; 
} 
if(!$im) return False; 
$srcW=ImageSX($im); 
$srcH=ImageSY($im); 
$dstX=0; 
$dstY=0; 
if ($srcW*$dstH>$srcH*$dstW) 
{ 
$fdstH = round($srcH*$dstW/$srcW); 
$dstY = floor(($dstH-$fdstH)/2); 
$fdstW = $dstW; 
} 
else 
{ 
$fdstW = round($srcW*$dstH/$srcH); 
$dstX = floor(($dstW-$fdstW)/2); 
$fdstH = $dstH; 
} 
$ni=ImageCreateTrueColor($dstW,$dstH); 
$dstX=($dstX<0)?0:$dstX; 
$dstY=($dstX<0)?0:$dstY; 
$dstX=($dstX>($dstW/2))?floor($dstW/2):$dstX; 
$dstY=($dstY>($dstH/2))?floor($dstH/s):$dstY; 
$white = ImageColorAllocate($ni,255,255,255); 
$black = ImageColorAllocate($ni,0,0,0); 
imagefilledrectangle($ni,0,0,$dstW,$dstH,$white);// ��䱳��ɫ 
ImageCopyResized($ni,$im,$dstX,$dstY,0,0,$fdstW,$fdstH,$srcW,$srcH); 
if($markwords!=null) 
{ 
$markwords=iconv("gb2312","UTF-8",$markwords); 
//ת�����ֱ��� 
ImageTTFText($ni,20,30,450,560,$black,"simhei.ttf",$markwords); //д������ˮӡ 
//��������Ϊ�����ִ�С|ƫת��|������|������|������ɫ|��������|�������� 
} 
elseif($markimage!=null) 
{ 
$wimage_data = GetImageSize($markimage); 
switch($wimage_data[2]) 
{ 
case 1: 
$wimage=@ImageCreateFromGIF($markimage); 
break; 
case 2: 
$wimage=@ImageCreateFromJPEG($markimage); 
break; 
case 3: 
$wimage=@ImageCreateFromPNG($markimage); 
break; 
} 
imagecopy($ni,$wimage,500,560,0,0,88,31); //д��ͼƬˮӡ,ˮӡͼƬ��СĬ��Ϊ88*31 
imagedestroy($wimage); 
} 
ImageJpeg($ni,$dstFile,$rate); 
ImageJpeg($ni,$srcFile,$rate); 
imagedestroy($im); 
imagedestroy($ni); 
} 
?>
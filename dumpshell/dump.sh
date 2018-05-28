#判断参数个数
if [ $# != 1 ]; then
echo "参数不正确"
echo "本命令只接收一个参数,参数是可执行文件的名称,请这样使用:dump name"
exit
fi
#通过遍历/var/mobile/Containers/Data/Application/中所有沙盒文件的.metadata.plist查找有参数$1的文件路径
cd /var/mobile/Containers/Data/Application/
for filename in `find . -name '*.metadata.plist'`
do
grep "$1" $filename
	if [ $? -eq 0 ]; then
		var=$filename
        break
	fi
done
dir=${var%/*}
documentDir=$dir"/Documents"
echo "document path ----> "$documentDir
echo "copy /var/root/dumpdecrypted.dylib ----> ${documentDir}"
cp /var/root/dumpdecrypted.dylib $documentDir
#切换到dumpdecrypted所在的目录
cd $documentDir
cmdpath=`find /var/containers/Bundle/Application/ -name "*$1"`
echo "---->DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib "$cmdpath
DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib $cmdpath

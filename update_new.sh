if [ -d /storage/xiaoya/mytoken.txt ]; then
	rm -rf /storage/xiaoya/mytoken.txt
fi
mkdir -p /storage/xiaoya
touch /storage/xiaoya/mytoken.txt
touch /storage/xiaoya/myopentoken.txt
touch /storage/xiaoya/temp_transfer_folder_id.txt

mytokenfilesize=$(cat /storage/xiaoya/mytoken.txt)
mytokenstringsize=${#mytokenfilesize}
if [ $mytokenstringsize -le 31 ]; then
	echo -e "\033[32m"
	read -p "输入你的阿里云盘 Token（32位长）: " token
	token_len=${#token}
	if [ $token_len -ne 32 ]; then
		echo "长度不对,阿里云盘 Token是32位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
		exit
	else	
		echo $token > /storage/xiaoya/mytoken.txt
	fi
	echo -e "\033[0m"
fi	

myopentokenfilesize=$(cat /storage/xiaoya/myopentoken.txt)
myopentokenstringsize=${#myopentokenfilesize}
if [ $myopentokenstringsize -le 279 ]; then
	echo -e "\033[33m"
        read -p "输入你的阿里云盘 Open Token（280位长）: " opentoken
	opentoken_len=${#opentoken}
        if [ $opentoken_len -ne 280 ]; then
                echo "长度不对,阿里云盘 Open Token是280位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
                exit
        else
        	echo $opentoken > /storage/xiaoya/myopentoken.txt
	fi
	echo -e "\033[0m"
fi

folderidfilesize=$(cat /storage/xiaoya/temp_transfer_folder_id.txt)
folderidstringsize=${#folderidfilesize}
if [ $folderidstringsize -le 39 ]; then
	echo -e "\033[36m"
        read -p "输入你的阿里云盘转存目录folder id: " folderid
	folder_id_len=${#folderid}
	if [ $folder_id_len -ne 40 ]; then
                echo "长度不对,阿里云盘 folder id是40位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
                exit
        else
        	echo $folderid > /storage/xiaoya/temp_transfer_folder_id.txt
	fi	
	echo -e "\033[0m"
fi

if ! grep "access.mypikpak.com" /storage/hosts >/dev/null
then
	echo -e "127.0.0.1\taccess.mypikpak.com" >> /storage/hosts
fi

if [ $1 ]; then
if [ $1 == 'host' ]; then
	docker stop xiaoya-hostmode
	docker rm xiaoya-hostmode
	docker pull xiaoyaliu/alist:hostmode
	docker run -d --network=host -v /storage/xiaoya:/data --restart=always --name=xiaoya-hostmode xiaoyaliu/alist:hostmode
	exit
fi
fi
docker stop xiaoya
docker rm xiaoya
docker pull xiaoyaliu/alist:latest
docker run -d -p 5678:80 -v /storage/xiaoya:/data --restart=always --name=xiaoya xiaoyaliu/alist:latest


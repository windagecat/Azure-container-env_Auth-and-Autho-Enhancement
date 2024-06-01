# JITアクセスハンズオン環境削除
JITアクセスハンズオン環境を削除します。<br>
>- 事前に、condiac-pim-testグループのメンバーシップから、すべてのユーザーを削除すること。
>- az loginで、アカウントを切り替えていること
 

下記コマンドを実行。
```powershell
# PIM用のグループと設定の削除
## .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\conditional_access_PIM\PIMへの移動
cd .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\conditional_access_PIM\PIM
## terraform destroyの実行
terraform destroy

# サービスプリンシパルおよびグループの削除
## .\Azure-container-env_Auth-and-Autho-Enhancement\conditinal_access\conditional_access_PIM\service_principalへの移動
cd .\Azure-container-env_Auth-and-Autho-Enhancement\conditinal_access\conditional_access_PIM\service_principal
## terraform destroyの実行
terraform destroy

# AKSの削除
## .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\Azureへの移動
cd .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\Azure
## terraform destroyの実行
terraform destroy
```
[PIMによるAKSの管理者ロールに対するJITアクセス](./PIMによるAKSに対するJITアクセス.md)のページへ戻る
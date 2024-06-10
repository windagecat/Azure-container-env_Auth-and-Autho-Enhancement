# JITアクセスハンズオン環境のデプロイ
JITアクセスハンズオン環境のデプロイを行います。
  - [前提条件](#前提条件)
  - [AKSのデプロイ](#aksのデプロイ)
  - [PIM設定のデプロイ](#pim設定のデプロイ)
    - [デプロイのためのサービスプリンシパルおよびグループの作成](#デプロイのためのサービスプリンシパルおよびグループの作成)
    - [PIM用のグループと設定のデプロイ](#pim用のグループと設定のデプロイ)

## 前提条件
- Azure CLIをインストールし、ログイン(az login)済みであること
- kubectlおよびkubeloginコマンドがインストールされていること
- terraformコマンドがインストールされていること
- Entra ID P2ライセンスがEntra IDに適用されていること

## AKSのデプロイ
AKSのデプロイをします。
```powershell
# .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\Azureへの移動
cd .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\Azure

# terraform initの実行
terraform init

# terraform applyの実行
terraform apply

#AKSのデプロイ確認
$env:KUBECONFIG = '../kubeconfig'
kubelogin convert-kubeconfig -l azurecli
kubectl get node --kubeconfig="../kubeconfig"

```
## PIM設定のデプロイ
### デプロイのためのサービスプリンシパルおよびグループの作成
> [条件付きアクセスの手順で作成し](./条件付きアクセスポリシーのサンプル.md#デプロイのためのサービスプリンシパルおよびグループの作成graph-apiトークンの取得)、かつ[クリーンアップ](./条件付きアクセスポリシーのサンプル.md#クリーンアップ)を行っていない場合は、この手順はスキップすること

デプロイのためのサービスプリンシパルおよびグループの作成します。
```powershell
# .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\conditional_access_PIM\service_principalへの移動
cd .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\conditional_access_PIM\service_principal

# terraform initの実行
terraform init

# terraform applyの実行
terraform apply
## 出力されるservice_principal_clientidとservice_principal_tenantidをメモする。
## カレントディレクトリのterraform.tfstateファイルを開き、「output」と検索してservice_principal_passwordをメモする。

# Azure portalへログインし、「Microsoft Entra ID」→「アプリ登録」→「すべてのアプリケーション」→「sp-xxxx」→「API のアクセス許可」→「既定のディレクトリで同意を与えます」→「はい」で、サービスプリンシパルのGraph APIに対するアクセス許可を設定
```
### PIM用のグループと設定のデプロイ
PIM用のグループと設定のデプロイします。
```powershell
# .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\conditional_access_PIM\PIMへの移動
cd .\Azure-container-env_Auth-and-Autho-Enhancement\conditinalaccess_PIM\conditional_access_PIM\PIM
# terraform.varsを編集し、前手順で取得したサービスプリンシパルの情報および、PIM管理者通知用のメールアドレスを入力
# terraform initの実行
terraform init

# terraform applyの実行
terraform apply

#PIMのUIで、k8sadmin-xxxx、k8scontributor-xxxx、armadmin-xxxx、armcontributor-xxxxが作成されていることを確認
```
次は、[JITアクセスハンズオン実施](./JITアクセスハンズオン実施.md)について説明します。

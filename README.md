# Arquitetura Serverless na AWS & Terraform 
`Projeto realizado para a matéria de Digital Product - BootCamp (Impacta - MBA Cloud Computing & DevOps)`\
\
Este repositório tem como objetivo demonstrar a criação de uma arquitetura serverless usando Terraform.

Pensando em cenários onde não desejamos nos preocupar em gerenciar uma infraestrutura de servidores, podemos optar em utilizar serviços serverless que faz essa camada de infra ser de responsabilidade do provedor (AWS, Azure, GCP). Com isso, na maioria das vezes ganhamos mais agilidade nas entregas, escalabilidade e redução de custos.

## __Arquitetura__
![Alt text](assets/arquitetura.png?raw=true "Arquitetura")\
Toda ela é criada via infraestrutura como código com o Terraform. [Veja aqui](terraform/)
### API Gateway
É a nossa porta de entrada, que vai encaminhar as chamadas HTTP para nossa função Lambda. 

_Com o API Gateway conseguimos criar APIs e administrar todo o recebimento de chamadas simultâneas. Sendo possível gerenciar todo o tráfego HTTP, configurar CORS, adicionar controle de acesso e até criar um controle de versões da nossa API._
### Lambda
Roda nossa [aplicação](src/) escrita em Python que vai nos permitir executar as operações `create, update, read, list, delete` em nossa tabela do DynamoDB.

_O serviço Lambda permite executar códigos sem se preocupar com o processamento do servidor, basta enviar o código e indicar qual é o método/função inicial._
### DynamoDB
Se trata do banco de dados que vamos usar para manter os dados na tabela `anything`.

_DynamoDB é um serviço de banco de dados NoSQL sem servidor e totalmente gerenciado que oferece suporte a estruturas de dados de documentos e chave-valor_

## __CI/CD__
Para subir todas as peças pode ser utilizado uma máquina na AWS com Terraform e Python3 (para executar os testes) instalado e o Jenkins configurado para que tudo seja feito de forma automatizada.
Então temos aqui no repo um [Jenkinsfile](Jenkinsfile) que pode ser utilizado na criação da esteira. Utilizando ele nós vamos ter os seguintes steps em nossa pipeline:\
`Checkout > Unit Test > Terraform init > Terraform plan > Terraform apply > Terraform destroy`\
Com o apply tudo será criado e no destroy tudo é destruído, por isso esses steps exigem a ação manual de escolher se deseja continuar ou abortar.

## __Run__
Para realizar as chamadas basta utilizar a url que será apresentada nos logs do step `Terraform apply` com o método HTTP POST e o body conforme os [exemplos aqui](payloads/), ou rodar os testes direto no API Gateway via console da AWS

## __CloudWatch Logs__
Além de todas as peças mencionadas acima, também estamos utilizando para nos ajudar com Troubleshootings um grupo de logs do CloudWatch que armazena e nos permite visualizar os logs da nossa Lambda, isto também foi criado via Terraform neste [ponto](https://github.com/cunha981/dynamodbmanager_function/blob/88d3838981a45f640565d01ece3c46796bbde249/terraform/main.tf#L54). Para acessar os logs basta entrar no CloudWatch Log Groups e buscar pelo nome da função `dynamodbmanager_function`



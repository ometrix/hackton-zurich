# NUWE-Zurich-Cloud-Hackathon

## English
--------
### INFRASTRUCTURE

The following resources have been created:

- Lambda Function: data_updater
- DynamoDB Table: clientData
- S3 bucket: awslambda-zhacked-bucket
- Policies: lambda_s3_policy, lambda_dynamodb_policy
- Roles: LambdaAdminRole

These main resources declared in the terraform file are the ones that allow the deployment and operation of what has been required which is that when uploading a file to the S3 bucket it triggers a lambda function that takes the information from the file and inserts it in a dynamodb table.

### PROCESS

In this process I have started by making the lambda function, creating this function and then testing it locally to verify that it works as expected.

After this we have started with the declaration of the infrastructure in the main.tf file, for this we have considered policies and accesses according to what is needed for each resource in this way the lambda function only has the possibility to read from the S3 bucket but not to write, but it does have read and write permissions in the dynamodb table.

After testing in local and AWS it was noticed that for it to work in local it was required that the lambda function had specified which endpoint should be used to try to use the default of aws, that is why in the lambda function it was decided to add a conditional at the beginning that if it detects a specific environment variable in the container that runs it determines whether it is in local or in AWS and use the appropriate settings for each one.

## Espaniol
---

### INFRAESTRUCTURA

Se ha creado los siguientes recursos:

- Lambda Function: data_updater
- DynamoDB Table: clientData
- S3 bucket: awslambda-zhacked-bucket
- Policys: lambda_s3_policy, lambda_dynamodb_policy
- Roles: LambdaAdminRole

Estos recursos principales declarados en el terraform file son los que permiten el despligue y funcionamiento de lo que se ha requierido que es al subir un archivo al bucket de S3 este dispare una funcion lambda que tome la informacion del archivo y la inserte en una tabla de dynamodb

### PROCESO

En este proceso he iniciado realizando la funcion lambda, creado esta funcion y luego realizando pruebas en local para verificar que esta funcione como se espera.

Luego de esto se ha iniciado con la declaracion de la infraestructura en el archivo main.tf, para esto hemos considerado politicas y accesos segun lo que se necesita para cada recurso de esta manera la funcion lambda solo tiene la posibilidad de leer del bucket de S3 mas no de escribir, pero si posee permisos de lectura y escritura en la tabla de dynamodb

Luego de realizar prueba en local como en AWS se noto que para que funcione en local se requeria que la funcion lambda tuviera espeficado que endpoint debia usar para que intentara usar el por defecto de aws, es por ello que en la funcionn lambda se decide agregar un condicional al inicio que si detecta una varia de entorno especifica en el contendor que la ejecuta esta determine si esta en local o en AWS y use la configuracion adecuada para cada una.
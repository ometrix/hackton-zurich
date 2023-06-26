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

In this process I have started making the lambda function, creating this function and then testing it locally to verify that it works as expected.

After this we have started with the declaration of the infrastructure in the main.tf file, for this we have considered policies and accesses according to what is needed for each resource, in this way the lambda function only has the ability to read from the S3 bucket, but not to write, but it does have read and write permissions on the dynamodb table.

After testing in local and AWS, it was noticed that for it to work in local it was required that the lambda function had to specify which endpoint to use because otherwise it would try to use by default the one in aws, that is why in the lambda function it was decided to add a conditional at the beginning, that if it detects a specific environment variable in the container that runs it determines if it is in local or in AWS and uses the appropriate configuration for each one.

This is how this solution can be used in test environments or in AWS itself.

## Espaniol
---

### INFRAESTRUCTURA

Se ha creado los siguientes recursos:

- Lambda Function: data_updater
- DynamoDB Table: clientData
- S3 bucket: awslambda-zhacked-bucket
- Politicas: lambda_s3_policy, lambda_dynamodb_policy
- Roles: LambdaAdminRole

Estos recursos principales declarados en el terraform file son los que permiten el despligue y funcionamiento de lo que se ha requierido que es al subir un archivo al bucket de S3 este dispare una funcion lambda que tome la informacion del archivo y la inserte en una tabla de dynamodb

### PROCESO

En este proceso he iniciado realizando la función lambda, creando esta función y luego realizando pruebas en local para verificar que esta funcione como se espera.

Luego de esto se ha iniciado con la declaración de la infraestructura en el archivo main.tf, para esto hemos considerado políticas y accesos según lo que se necesita para cada recurso, de esta manera la función lambda solo tiene la posibilidad de leer del bucket de S3, mas no de escribir, pero si posee permisos de lectura y escritura en la tabla de dynamodb

Luego de realizar prueba en local como en AWS, se notó que para que funcione en local se requería que la función lambda tuviera especificado que endpoint debía usar porque de otra manera intentara utilizar por defecto el de aws, es por ello por lo que en la función lambda se decide agregar un condicional al inicio, que si detecta una variable de entorno específica en el contendor que la ejecuta determina si está en local o en AWS y usa la configuración adecuada para cada una.

Es asi como esta solucion puede ser utilizada en entornos de prueba o en el propio AWS

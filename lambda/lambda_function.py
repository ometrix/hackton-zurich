import boto3
import json
import os

# Configurar cliente de Amazon S3, Verifica si esta corriendo en local o AWS
if os.environ.get("LOCALSTACK_HOSTNAME"):
    s3 = boto3.client('s3',endpoint_url='http://' + os.environ["LOCALSTACK_HOSTNAME"] + ':4566')
else:
    s3 = boto3.client('s3')

    
# Crear un cliente de DynamoDB, Verifica si esta corriendo en local o AWS
if os.environ.get("LOCALSTACK_HOSTNAME"):
    dynamodb = boto3.resource('dynamodb', endpoint_url='http://' + os.environ["LOCALSTACK_HOSTNAME"] + ':4566')
else:
    dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
    # Obtener información del archivo JSON desde el evento de Lambda
    json_data = event['Records'][0]['s3']['object']['key']

    # Descargar el archivo JSON desde S3
    response = s3.get_object(Bucket='awslambda-zhacked-bucket', Key=json_data)
    
    # Leer el contenido del archivo JSON
    json_content = response['Body'].read().decode('utf-8')
    
    # Procesar el contenido JSON
    data = json.loads(json_content)
    
    # Seleccionar la tabla de DynamoDB
    table = dynamodb.Table('clientData')
    
    # Insertar los datos en la tabla de DynamoDB
    for item in data:
        table.put_item(Item=item)
    
    # Retornar una respuesta
    return {
        'statusCode': 200,
        'body': 'Data inserted successfully'
    }